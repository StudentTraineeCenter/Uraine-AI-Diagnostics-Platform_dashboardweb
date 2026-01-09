// lib/services/dashboard_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientSummary {
  final String userId;
  final DateTime lastUpdate;
  final bool isCritical;
  final String lastColor;
  final String lastClarity;

  PatientSummary({
    required this.userId,
    required this.lastUpdate,
    required this.isCritical,
    required this.lastColor,
    required this.lastClarity,
  });
}

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PatientSummary>> getPatientsStream() {
    print("DEBUG: Spúšťam stream pre kolekciu 'analyses'..."); // LOG 1

    return _db
        .collection('analyses')
        .orderBy('createdAt', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      
      print("DEBUG: Firestore vrátil ${snapshot.docs.length} dokumentov."); // LOG 2
      
      if (snapshot.docs.isEmpty) {
         print("DEBUG: Kolekcia je prázdna alebo nemám práva na čítanie.");
      }

      Map<String, PatientSummary> uniquePatients = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        // DEBUG výpis pre prvý dokument, aby sme videli štruktúru
        if (doc == snapshot.docs.first) {
           print("DEBUG: Dáta prvého dokumentu: $data");
        }

        final userId = data['userId'] as String? ?? 'unknown';

        if (uniquePatients.containsKey(userId)) continue;

        String zakal = (data['zakal'] ?? 'Neznámy').toString();
        String farba = (data['farba'] ?? 'Neznáma').toString();
        
        // Detekcia rizika
        bool isRisk = (data['isRisk'] == true) || 
                      zakal.toLowerCase().contains('vysoký') || 
                      farba.toLowerCase().contains('červená');

        DateTime dt = DateTime.now();
        if (data['createdAt'] != null) {
          try {
             dt = (data['createdAt'] as Timestamp).toDate();
          } catch (e) {
             print("DEBUG Error dátum: $e");
          }
        }

        uniquePatients[userId] = PatientSummary(
          userId: userId,
          lastUpdate: dt,
          isCritical: isRisk,
          lastColor: farba,
          lastClarity: zakal,
        );
      }

      var list = uniquePatients.values.toList();
      
      list.sort((a, b) {
        if (a.isCritical && !b.isCritical) return -1;
        if (!a.isCritical && b.isCritical) return 1;
        return b.lastUpdate.compareTo(a.lastUpdate);
      });
      
      print("DEBUG: Po spracovaní mám ${list.length} unikátnych pacientov."); // LOG 3
      return list;

    }).handleError((error) {
      // TOTO JE KĽÚČOVÉ - Zachytí to chybu oprávnení
      print("CRITICAL FIREBASE ERROR: $error");
      return <PatientSummary>[];
    });
  }

  Stream<Map<String, int>> getStatsStream() {
    return getPatientsStream().map((patients) {
      int critical = patients.where((p) => p.isCritical).length;
      
      int today = patients.where((p) {
        final now = DateTime.now();
        return p.lastUpdate.year == now.year && 
               p.lastUpdate.month == now.month && 
               p.lastUpdate.day == now.day;
      }).length;
      
      return {
        'total': patients.length,
        'critical': critical,
        'today': today,
      };
    });
  }
}
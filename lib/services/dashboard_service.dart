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
    return _db
        .collection('analyses')
        .orderBy('createdAt', descending: true)
        .limit(100) // OPTIMALIZÁCIA: Načítame len posledných 100 záznamov
        .snapshots()
        .map((snapshot) { // Zmenil som asyncMap na map pre rýchlosť
      
      Map<String, PatientSummary> uniquePatients = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String? ?? 'unknown';

        if (uniquePatients.containsKey(userId)) continue;

        String zakal = (data['zakal'] ?? 'Neznámy').toString();
        String farba = (data['farba'] ?? 'Neznáma').toString();
        
        // Detekcia rizika (ak je string 'vysoký' alebo 'červená', alebo flag isRisk)
        bool isRisk = (data['isRisk'] == true) || 
                      zakal.toLowerCase().contains('vysoký') || 
                      farba.toLowerCase().contains('červená');

        DateTime dt = DateTime.now();
        if (data['createdAt'] != null) {
          try {
             dt = (data['createdAt'] as Timestamp).toDate();
          } catch (_) {}
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
      
      // Zoradenie: Kritickí prví, potom podľa času
      list.sort((a, b) {
        if (a.isCritical && !b.isCritical) return -1;
        if (!a.isCritical && b.isCritical) return 1;
        return b.lastUpdate.compareTo(a.lastUpdate);
      });

      return list;
    });
  }

  Stream<Map<String, int>> getStatsStream() {
    return getPatientsStream().map((patients) {
      int critical = patients.where((p) => p.isCritical).length;
      
      // Počet dnešných unikátnych pacientov
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
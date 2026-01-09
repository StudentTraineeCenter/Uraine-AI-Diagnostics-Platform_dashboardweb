// lib/screens/patient_profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uraine_web/theme/app_colors.dart';
import 'package:uraine_web/widgets/dashboard_card.dart';

class PatientProfileScreen extends StatelessWidget {
  final String userId;
  final String patientName;

  const PatientProfileScreen({
    super.key,
    required this.userId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // Stream pre meno pacienta v Title
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var data = snapshot.data!.data() as Map<String, dynamic>;
                // Bezpečné načítanie mena
                String name = data['fullName'] ?? data['name'] ?? "Detail Pacienta";
                return Text(
                  name,
                  style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
                );
              }
              return const Text("Načítavam...", style: TextStyle(color: AppColors.textGrey));
            },
          ),
          bottom: const TabBar(
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryBlue,
            tabs: [
              Tab(text: "Prehľad"),
              Tab(text: "História Meraní"),
              Tab(text: "Dokumenty"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildHistoryTab(context),
            _buildDocumentsTab(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ZÁLOŽKA 1: PREHĽAD (OVERVIEW)
  // ---------------------------------------------------------------------------
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientHeaderInfo(), // Fixnuté načítanie dátumov

          const SizedBox(height: 24),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('analyses')
                .where('userId', isEqualTo: userId)
                .orderBy('createdAt', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyState("Pacient zatiaľ nemá žiadne analýzy.");
              }

              var doc = snapshot.data!.docs.first;
              var data = doc.data() as Map<String, dynamic>;
              Map<String, dynamic> params = data['bioParameters'] ??
                  { "pH": "-", "Glukóza": "-", "Bielkoviny": "-", "Krv": "-" };

              return Column(
                children: [
                  // AI Diagnostika Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [
                          Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text("Posledná AI Diagnostika", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ]),
                        const SizedBox(height: 12),
                        Text(
                          data['aiAnalysis'] ?? "Analýza sa spracováva...",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  // Grid parametrov
                  LayoutBuilder(builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.6,
                      children: params.entries.map((e) {
                        return _buildParamCard(e.key, e.value.toString());
                      }).toList(),
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ZÁLOŽKA 2: HISTÓRIA (HISTORY)
  // ---------------------------------------------------------------------------
  Widget _buildHistoryTab(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('analyses')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return _buildEmptyState("Žiadna história meraní.");

        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            
            // Bezpečný dátum
            DateTime date = DateTime.now();
            if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
               date = (data['createdAt'] as Timestamp).toDate();
            }
            
            String zakal = (data['zakal'] ?? '').toString();
            bool isRisk = zakal.toLowerCase().contains('vysoký') || (data['isRisk'] == true);

            return InkWell(
              onTap: () => _showAnalysisDetail(context, data, date),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isRisk ? Colors.red.shade50 : Colors.blue.shade50,
                    child: Icon(isRisk ? Icons.warning_amber : Icons.science, color: isRisk ? Colors.red : AppColors.primaryBlue),
                  ),
                  title: Text(DateFormat('dd. MMMM yyyy, HH:mm').format(date), style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Farba: ${data['farba']} • Zákal: $zakal", style: const TextStyle(color: Colors.grey)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MODÁLNE OKNO - DETAIL
  // ---------------------------------------------------------------------------
  void _showAnalysisDetail(BuildContext context, Map<String, dynamic> data, DateTime date) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Detail Merania", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(DateFormat('dd. MMMM yyyy - HH:mm').format(date), style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                    ],
                  ),
                  const Divider(height: 32),
                  
                  // FOTKA - S OPRAVOU PRE CORS ERROR
                  if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty)
                    Container(
                      height: 250,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        data['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Tu zachytávame chybu HTTP 0 / CORS, aby appka nespadla
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.broken_image_rounded, color: Colors.grey, size: 40),
                                SizedBox(height: 8),
                                Text("Obrázok sa nedá načítať (CORS obmedzenie)", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  Row(
                    children: [
                      Expanded(child: _buildDetailBox("Farba", data['farba'] ?? "?", Icons.colorize, Colors.amber)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDetailBox("Zákal", data['zakal'] ?? "?", Icons.opacity, Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  const Text("Interpretácia AI:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(data['aiAnalysis'] ?? "Bez interpretácie", style: const TextStyle(color: AppColors.primaryDark, height: 1.4)),
                  ),
                  
                  const SizedBox(height: 24),
                  if (data['symptoms'] != null) ...[
                     const Text("Priradené symptómy:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     const SizedBox(height: 8),
                     Wrap(
                       spacing: 8,
                       children: (data['symptoms'] as List).map((s) => Chip(
                         label: Text(s.toString()), 
                         backgroundColor: Colors.red.shade50,
                         labelStyle: TextStyle(color: Colors.red.shade700),
                       )).toList(),
                     )
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ZÁLOŽKA 3: DOKUMENTY
  // ---------------------------------------------------------------------------
  Widget _buildDocumentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('documents').orderBy('uploadedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_off_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text("Žiadne dokumenty v karte pacienta.", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(doc['title'] ?? 'Dokument'),
                subtitle: Text("Dokument"),
                trailing: IconButton(icon: const Icon(Icons.download), onPressed: () {}),
              ),
            );
          },
        );
      },
    );
  }

  // --- UI HELPERY A FIX DÁTUMOV ---

  Widget _buildPatientHeaderInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        String name = userData['fullName'] ?? userData['name'] ?? 'Neznámy';
        String email = userData['email'] ?? 'Bez emailu';

        // --- OPRAVA CHYBY TIMESTAMP ---
        // Skontrolujeme, či je birthDate String alebo Timestamp
        String birthDate = '-';
        if (userData['birthDate'] != null) {
          try {
            if (userData['birthDate'] is Timestamp) {
              birthDate = DateFormat('dd.MM.yyyy').format((userData['birthDate'] as Timestamp).toDate());
            } else {
              birthDate = userData['birthDate'].toString();
            }
          } catch (e) {
            birthDate = "Chyba formátu";
          }
        }
        // -----------------------------

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.secondaryGreen.withOpacity(0.2),
                child: Text(name.isNotEmpty ? name[0] : "?", style: const TextStyle(fontSize: 24, color: AppColors.secondaryGreen, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(email, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.cake_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text("Narodenie: $birthDate", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildParamCard(String title, String value) {
    bool isNegative = value.toLowerCase().contains("negat") || value == "Norma";
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isNegative ? Colors.transparent : AppColors.errorRed.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: TextStyle(color: isNegative ? AppColors.primaryDark : AppColors.errorRed, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDetailBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
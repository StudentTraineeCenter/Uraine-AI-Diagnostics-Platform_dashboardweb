# 🩺 URAINE MD: Professional Medical Dashboard

> **Telemedicínsky riadiaci uzol pre proaktívnu diagnostiku a monitoring pacientov.**

## 🌐 O portáli URAINE MD

**URAINE MD** je webová nadstavba celého ekosystému, určená výhradne pre lekárov a zdravotnícky personál. Zatiaľ čo mobilná aplikácia slúži na zber dát od pacientov, tento portál slúži ako **analytické centrum**. Umožňuje lekárom prejsť od reaktívneho riešenia akútnych stavov k inteligentnému, proaktívnemu sledovaniu trendov v reálnom čase.

---

## ✨ Kľúčové Inovácie (The "Wow" Factors)

### 1. ⚡ Real-time Clinical Feed

Využitím **Cloud Firestore** synchronizácie portál nepotrebuje manuálne obnovovanie. Akonáhle Azure AI spracuje snímku pacienta doma, výsledok sa v priebehu milisekúnd objaví na lekárovom dashboarde.

* **Urgency Filtering:** Systém automaticky prioritizuje pacientov, u ktorých AI detegovala kritické anomálie (napr. vysoký zákal alebo patologické sfarbenie).

### 2. 📊 Trend Analytics & Symptom Correlation

Lekár nevidí len posledné meranie, ale kompletnú **vizuálnu históriu**.

* Grafy korelujú výsledky AI analýzy s denníkom symptómov, ktoré si pacient zaznamenáva.
* To umožňuje lekárovi vidieť "celkový obraz" (napr. nárast bolesti súbežne so zhoršujúcou sa kvalitou vzorky).

### 3. 🛡️ High-Level Security Infrastructure

Keďže portál pracuje s najcitlivejšími údajmi, implementoval som:

* **Firebase Auth integration:** Bezpečné prihlasovanie pre overených špecialistov.
* **Granular Access Control:** Dáta sú štruktúrované tak, aby lekár videl len tých pacientov, ktorí mu udelili súhlas na monitorovanie (Data Bridge).

### 4. 📄 Automatizovaný Export Správ (`PdfService`)

V kóde máš pripravenú logiku pre generovanie PDF reportov. Portál umožňuje lekárovi jedným kliknutím vytvoriť oficiálnu lekársku správu z histórie meraní, ktorá je pripravená na tlač alebo priloženie do štátneho e-Health systému.

---

## 🛠️ Technologický Zásobník (Web Stack)

| Komponent | Technológia |
| --- | --- |
| **Framework** | Flutter Web (Dart) |
| **State Management** | Provider / BLoC pattern |
| **Real-time DB** | Google Firebase Cloud Firestore |
| **AI Processing** | **Microsoft Azure AI** (via Cloud Functions Orchestrator) |
| **File Storage** | Firebase Storage (Prístup k pôvodným snímkam vzoriek) |

---

## 🚀 Spustenie Webovej Verzie

1. **Príprava prostredia:**
Uisti sa, že máš nainštalovaný Flutter SDK s povolenou podporou pre web.
```bash
flutter config --enable-web

```


2. **Získanie balíkov:**
```bash
flutter pub get

```


3. **Lokálne spustenie:**
```bash
flutter run -d chrome

```


4. **Build pre produkciu (Hosting):**
```bash
flutter build web

```



---

## 🏛️ Architektúra Dátového Mosta

1. **Pacient** vykoná meranie cez mobilnú aplikáciu.
2. **Azure AI** v cloude vyhodnotí markery.
3. **URAINE MD** okamžite prijíma signál o novom výsledku.
4. **Lekár** vyhodnotí stav a proaktívne kontaktuje pacienta cez integrované notifikácie.

---

## 👤 Vývoj a Vízia

**Milan Smieško**

* Microsoft STC Trainee
* *Cieľ:* Prepojenie moderného Cloudu s každodennou medicínskou praxou pre záchranu životov.

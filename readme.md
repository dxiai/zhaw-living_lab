# Kurzbeschreibung, Partner und Ziele des Gesamtprojektes:
> Bislang hat die physische Umgebung bzw. die räumliche Komponente von Kollaborationsräumen wenig Beachtung erhalten. Es kann davon ausgegangen werden, dass Erkenntnisse zu Büro- und Meetingräumen auf Kollaborationsräume (mindestens teilweise) übertragbar sind (z.B. **tätigkeits- und bedürfnisorientierte Gestaltung von Umgebungen**). Dadurch ergeben sich erste Einflussfaktoren auf das Verhalten von Workshop-Teilnehmenden und indirekt auf die Kollaborations-Ergebnisse, die Working-Performance und somit auch auf die Nachhaltigkeit. Ergänzend könnte die Organisation (vor, während und anschliessend) von Kollaborationsprozessen verbessert und mit Raum und räumlichtechnischer Infrastruktur synchronisiert werden.
Damit das *Wechselspiel zwischen Menschen, Prozessen und Ort* aus dem Blickwinkel des Immobilien- und Facility Management erforschbar wird, richtet das IFM im Gebäude RA eine FCE nach dem Konzept des **Living Lab** ein. So können unter realen Bedingungen verschiedene Aspekte des Nutzerverhaltens (Aktion und Reaktion) erfasst und durch die Umgebung (Raum und Technik) unterstützt/beeinflusst werden (mit Standard-Gebäudetechnik nicht darstellbar). Die Raumparameter wie z.B. zugeordnete Lichtfarben oder unterschiedliche gestaltete Zonen werden im Raum symbolisch abgebildet und damit transparent gemacht. Pfade durch den Raum unterstützen den Phasen-Prozess von Workshops, indem sie den Fortschritt räumlich und umgebungstechnisch wiederspiegeln. Weitere Raumparameter, die manipulierbar und reaktionsschnell angesprochen werden sollen, sind **Klima (Temperatur und Feuchtigkeit), Akustik (z.B. Unterlegung von Tönen aus der Natur) und Olfaktorik (Raumduft)**. Die Raumparameter werden entweder voll programmgesteuert, semi-automatisch oder manuell veränderbar.
Die unterstützten bzw. zu erforschenden Nutzerprozesse im Zusammenspiel mit dem Raum können Kollaborationsprozesse aller Art sein (kolozierte Meetings oder Workshops, COIL-Sitzungen, Experimentierraum für Forschungsprojekte zu Integration Raum, Nutzer, Technologie und Prozess; Anschauungs-Beispiel für Unterricht zu Sensoren, Smart Building u.ä.; Service Design Workshops).
Diese FCW wird für alle für ZHAW-Angehörige, Studierende, Dozierende, Wirt-schafts-/Projektpartner nutzbar sein, regulär oder im «Labor- bzw. Forschungsmodus».
Die FCE unterstützt die Zusammenarbeit mit anderen Instituten des Departements LSFM (z.B. mit dem IAS in Themen wie X-Reality und IoT/Business Analytics). Zudem bietet die FCE eine Plattform zur Zusammenarbeit mit Wirtschaftspartnern; so können beispielsweise Pilotprojekte mit KMUs und Herstellern entwickelt und getestet werden. (2020, Carsten Druhmann)

# Beschreibung und Ziele!
> Alle technischen Komponenten bzw. Massnahmen sollen durch eine IT-basierte Lösung gesteuert werden, die es ermöglicht, die **Eigenschaften des Raums mit den verschiedenen Kollaborationsprozessen abzustimmen bzw. diesen zu unterstützen und/oder zu steuern (vgl. obige Ausführungen)**. Zudem sollen **Daten über verschiedene Sensoren im Raum gesammelt und ausgewertet werden** können.
Dazu ist eine Vernetzung und Ansteuerbarkeit der einzelnen Komponenten mit ihren verschiedenen Protokollen herzustellen und eine Steuerungsplattform zu implementieren. Im Rahmen dieses Anschubprojektes werden Nutzerprofile und die zugehörigen Raum-/Umgebungs-Beeinflussungsprogramme inkl. Datenmodell definiert und ein Mockup erstellt. Anschliessend werden die technischen Komponenten hinsichtlich Datenerhebung, und -austausch, Datenspeicherung vernetzt, mit einer zu programmierenden Plattform als zentralem Element. Diese wird in der Praxis erprobt und bis Projektende iterativ verbessert.
Die «physisch-technische» Vernetzung (z.B. Elektronik) ist nicht Gegenstand dieses Anschubprojektes. (2020, Carsten Druhmann)

# Methode
## Ausgangslage
### Projekt MultiMico
Das dxiai Projekt MultiMico unter Leitung von Dr. Christian Glahn beinhaltet die Beantwortung folgender Forschungsfrage: 
> Der aktuelle Stand der Forschung zeigt eine grosse Lücke in Bereich der Gestaltung und dem Arrangement von bestehenden Informationssystemen zu multimodalen 
Systemen für konkrete Prozesse und Anwendungen.
Daraus ergibt sich direkt die zentrale Forschungsfrage für dieses Projekt:
**Welche Gestaltungselemente und Daten strukturieren multimodale Interaktionen und können zur Prozesssteuerung in heterogenen Geräteumgebungen genutzt werden?**
Diese Frage greift die aktuelle Entwicklung der Kapselung und Skalierung von Ressourcen im Cloud-Computing auf und richtet den Fokus auf die Interaktion im sogenannten Edge-ComputingUmgebungen, in denen Smartphones, PCs und Tablets im Verbund mit anderen Komponenten komplexe «Erlebnisräume» schaffen, was sowohl im aktuellen Diskurs und in der technischen Anwendung unterrepräsentiert ist. (2020, Christian Glahn)

Konzepte, Methoden und bereits umgesetzte Komponenten aus MultiMico werden zur Erreichnung der Living Lab Projektziele unterstützend eingesetzt. 

### Living_lab Location
Der physische Living Lab Raum befindet sich im Raum 217 im ZHAW, Campus Reidbach, Gebäude RA. Der aktuelle Stand Plazierung und Anschluss der aktuell sichtbaren Aktuatoren:
-|-|
![IoT_inventory](/assets/images/screens_unpacked.jpeg)

![IoT_inventory](/assets/images/dyson_philips.jpeg)
(FOTO Panorama)

### IT-Infrastruktur
Die IT-Infrastruktur setzt sich aus Daten- Verarbeitung und - Kommunkation Systemen, Sensoren und Aktuatoren zusammen. Die folgende tabellarische Aufstellung zeigt die zur Verfügung stehenden Geräte und Systemkomponenten.

![IoT_inventory](/assets/images/IoT_inventory.jpeg)

Daten- Verarbeitung und - Kommunkation:
Menge|Artikel|Details|Einsatz
-|-|-|-
2| Raspberry Pi4B| 4GB| Daten- Verarbeitung und - Kommunkation
3| Raspberry Pi Stacking Header| 40-polig, RM| Daten- Verarbeitung und - Kommunkation
2| Grove Sonnenlicht-Sensor| v1.0, SI1145| Sensor
3| Grove Digital Licht-Sensor| TSL2561| Sensor
3| Grove Soundsensor| LM386| Sensor
3| SONOFF Temp. und Luftfeuchtesensor||Sensor
1| SONOFF 1 Kanal Schaltaktor ZigBee||Aktuator
2| Tür/Fensterkontakt| WLAN| Sensor
1| SONOFF Smarte IP Überwachungskamera| WLAN| Sensor
1| SONOFF Smarter Schalter||Sensor
5| MicroSDHC-Speicherkarte| 16GB Kingston| Daten- Verarbeitung und - Kommunkation
3| Gehäuse für Raspberry Pi 3| Aluminium Schwarz| Daten- Verarbeitung und - Kommunkation
9| 1 Kanal Schaltaktor WLAN| mit Messfunktion| Aktuator
3| Raspberry Pi Netzteil| 5.1V, 3.0A| Daten- Verarbeitung und - Kommunkation
3| Grove HCHO-Sensor7 WSP2110| Sensor
3| Raspberry Pi Kühlgehäuse Pi4| schwarz| Daten- Verarbeitung und - Kommunkation
3| Grove Raspberry Pi Shield| Base HAT| Daten- Verarbeitung und - Kommunkation

### Vorgehen
In einem ersten Schritt soll eine Machbarkeitsstudie in Form eines Demonstrators entwickelt werden, der:

- die für die Machbarkeitsstudie gewählten technischen Komponenten bzw. Massnahmen durch eine IT-basierte Lösung steuert
- die Eigenschaften des Raums mit den verschiedenen Kollaborationsprozessen abstimmt
- die Daten über verschiedene Sensoren im Raum sammelt und ausgewertet
- mit den einzelnen Komponenten mit ihren verschiedenen Protokollen transparent kommuniziert
- individuelle Datenprofile und Nutzerprofile erlaubt
- die erfassten Daten der einzelnen Systemkomponenten hinsichtlich Datenerhebung, und -austausch vernetzt und via API zugänglich macht.

Die «physisch-technische» Vernetzung (z.B. Elektronik) ist nicht Gegenstand dieses Anschubprojektes.

Für den Demonstrator entscheiden wir uns für die Erfassung der Raumparameter Temperatur, Feuchtigkeit, Licht, Geräusch. Eine IP Kamera ergänzt die so erfassten Raumdaten durch einen optischen Sensor, über den sich zusätzliche visuelle Informationen zu den Raumverhältnissen gewinnen lassen. Die Raumparameter werden entweder voll programmgesteuert, semi-automatisch oder sind manuell veränderbar.

### System Anforderungen
**Gesamtsystem**
- Daten Repository
- Übertragungsmedien
- Verfügbarkeit
- Kontrolle/Einflussname
- "Home/Office" Automation Plattform
  - Open Source
  - Grosse Anzahl aktive Entwickler
  - offenes API
  - agnostisch

**Lokal**
- Sensoring
- Übertragungsmedien
- Microcomputing
- Edge-Computing

**Remote**
- Datenzugriff
- Aktuatorensteuerung
- Profilierung
- Übertragungsmedien

Ein Überblick über die gebräuchlichsten Homeautomation Standards, Medien und Systeme *Quelle:*[hausinfo.ch](https://hausinfo.ch/de/bauen-renovieren/haustechnik-vernetzung/smart-home-verkabelung-gebaeudeautomationen/systeme.html)

**Kommunikationsstandard**|	**Übertragungsmedium**|	**Smart-Home-Systeme** 
-|-|-
Definiert Form und Struktur der Signalübertragung| Bildet den physikalischen Weg der Datenübertragung| Liefern die für die Übertragung notwendige Infrastruktur| 
Z-Wave, WLAN, - ZigBree, - KNX-RF/PL/TP (für Radio Frequency, also Funk, Power Line, Twisted Pair), - Bluetooth, - DECT, - HomeMatic| Funk (868 Mega-Hertz, 2,4 Giga-Hertz oder andere Frequenzen), - Power Line (PL, Übertragung über das Stromnetzkabel), - Datenleitung mit Glasfasern (FTTH: Fiber to the Home) oder Kupferkabeln (TP, Twisted Pair)| HomeKit von Apple läuft mit WLAN, - DigitalSTROM ist zugleich eigener Standard und nutzt Power Line. - Devolo arbeitet mit dem Z-Wave., - Qivicon ist mit HomeMatic kompatibel, - INNOXEL läuft über den CAN-Bus


### Wahl einer geeigneten "Smart Home/Office Automation" Plattform
Mittlerweile ist Home Automation kein Nischenthema mehr, sondern hat sich zu einer veritablen Indutrie mit unzähligen Anwendungsmöglichkeiten entwickelt.
Die Neuentwicklung eines kompletten Ecosystems macht deshlab keinen Sinn. Aus Sicht einer Bildungsinstitution wie der ZHAW sind **offene Systeme** mit einem Open Standard, verfügbarer API, grosser und breit gefächerter Entwicklergemeinschaft sowie eine Vielzahl unterschiedlicher Anwendungen wichtiger als hochoptimierte, oft komplex zu bedienende und teure **geschlossene Systeme**. Zudem können bei den offenen Systemen Sensoren und Aktuatoren unterschiedlicher Hersteller eingesetzt werden, während sich die Anzahl bei geschlossenen Systemen auf die eines Herstellers und seines Partnernetzuwerkes beschränkt.
[Home&Smart.de](https://www.homeandsmart.de/smart-home-systeme-vergleich) bietet einen umfassenden Vergleich von 2021 erhältlichen Home Automation Anbietern, Plattformen sowie Sensoren und Aktuatoren. Über die folgende Liste kommt man zu einer Kurzbeschreibung und -Redaktionsbewertung der vorgestellten SmartHome System Anbieter.
Smart Home System Anbieter |||
-|-|-
[AVM FRITZ! Smart Home-System](https://www.homeandsmart.de/fritz-box-smart-home)| [Belkin WeMo System](https://www.homeandsmart.de/belkin-wemo)| [Bosch Smart Home-System](https://www.homeandsmart.de/bosch-smart-home-system-controller)
[Brennenstuhl / BrematicPRO](https://www.homeandsmart.de/brennenstuhl-brematic-smart-home)| Busch Jäger| [devolo Home Control System](https://www.homeandsmart.de/devolo-home-control-smart-home-zum-selbermachen)
[eNet SMART HOME](https://www.enet-smarthome.com/de/)| [Digitalstrom](https://www.homeandsmart.de/einfach-ins-smart-home-digitalstrom-macht-auch-normale-technik-smart)| [Eberle Wiser](https://www.homeandsmart.de/eberle-wiser-smarte-mehrzonen-heizungssteuerung)
[Eve Systems](https://www.homeandsmart.de/elgato-eve-homekit-sensoren-smart-home-siri-steuerung)| [Egardia Smart Home](https://www.homeandsmart.de/egardia-funk-alarmanlage-all-in-one)| [GARDENA (nur Garten-System)](https://www.homeandsmart.de/gardena-smart-system-smart-garden)
[Gigaset elements System (nur Sicherheits-System)](https://www.homeandsmart.de/gigaset-elements-smart-home-system-sensoren)| [HomeMatic IP System](https://www.homeandsmart.de/homematic-ip-eq-3-hausautomation)| [innogy Smart Home-System](https://www.homeandsmart.de/innogy-smarthome)
iSmart Alarm (nur Sicherheits-System)| [Homee (multikompatible Zentrale)](https://www.homeandsmart.de/homee-verbindet-smart-home-geraete-mit-homkit)| [Loxone](https://www.homeandsmart.de/loxone-smart-home) 
[Mydlink Home](https://www.homeandsmart.de/mydlink-home-smart-home-system)| [QIVICON System](https://www.homeandsmart.de/qivicon-smart-home-plattform)| [Rademacher](https://www.homeandsmart.de/rademacher-smart-home-system-test)
[Samsung SmartThings](https://www.homeandsmart.de/samsung-smartthings-kompatible-geraete)| [Schellenberg](https://www.homeandsmart.de/schellenberg-smart-home-system)| Schwaiger Home4You (multikompatible Zentrale)
[SMART HOME by hornbach](https://www.homeandsmart.de/hornbach-smart-home-test)| Somfy TaHoma | Zipato Zipatile


Die Suche nach "Open Source Home Automation App Design" tools in Google findet man rasch eine umfassende Zusammenstellung auf [ubidots](https://ubidots.com/blog/open-source-home-automation/)




# Fényképalbum

**OpenShift** PaaS környezetbe deploy-olható **Django** keretrendszerrel és **SQLite** lokális adatbázissal elkészített fényképalbum alkalmazás.

## A program funkciói
- Fényképek feltöltése az albumba:
  - egy képnek automatikusan a fájl nevét adja meg,
  - a kép neve feltöltés előtt változtatható 40 karakter hosszig,
  - a feltöltés dátuma is elmentésre kerül,
  - egyező nevű képek nem szerepelhetnek az albumban.

- Fényképek törlése az albumból.

- Fényképek listázása:
  - történhet név vagy dátum szerint, növekvő vagy csökkenő sorrendben rendezve.

- A listában megjelenő elemek tartalmazzak a kép nevét, előnézetét és feltöltési dátumát:
  - az adott elemre kattintva annak teljes felbontású változata tekinthető meg.

# Fényképalbum

**OpenShift** PaaS környezetbe deploy-olható **Django** keretrendszerrel és **PostgreSQL** adatbázissal elkészített fényképalbum alkalmazás.

## A program funkciói
- **Fényképek feltöltése az albumba:**
  - egy képnek automatikusan a fájl nevét adja meg,
  - a kép neve feltöltés előtt változtatható 40 karakter hosszig,
  - a feltöltés dátuma is elmentésre kerül,
  - egyező nevű képek nem szerepelhetnek az albumban.

- **Fényképek törlése az albumból.**

- **Fényképek listázása:**
  - történhet név vagy dátum szerint, növekvő vagy csökkenő sorrendben rendezve.

- **A listában megjelenő elemek tartalmazzak a kép nevét, előnézetét és feltöltési dátumát:**
  - az adott elemre kattintva annak teljes felbontású változata tekinthető meg.

- **Felhasználókezelés:**
  - Django-beépített regisztráció, be- és kijelentkezés,
  - csak bejelentkeztett felhasználók tudnak fényképeket feltölteni,
  - minden felhasználó csak a saját általa feltöltött fényképeket tudja törölni.

## IaC setup
- **Használt eszközök:**
	- RedHat OpenShift, Terraform, GitHub Actions/Secrets

- **Konfiguráció:**
	- _Deploy folyamat_: Kód push-olása esetén lefut a GitHub Actions workflow, ami terraform init és apply parancsokkal létrehozza vagy frissíti a szükséges OpenShift erőforrásokat.
	- _Alkalmazás réteg_:
		- Deployment: OpenShift-re importált egyedi image-et futtatja (django-image:latest).
		- HPA: A skálázás feladatrészben beállított módon a Terraform is létrehozza ezt.
		- Route: Webes elérést biztosít a fényképalbum applikációhoz.
	- _Adatbázis réteg_:
		- PVC: Tárhely a felhasználók és képek megőrzéséhez
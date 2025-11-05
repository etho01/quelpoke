# quelpoke

Application web en Go qui affiche « Quel Pokémon es-tu ? » en fonction d'un prénom et interroge la PokeAPI.

## Lancer avec Docker

Un `Dockerfile` multi-étapes est fourni. Il construit un binaire statique puis l'exécute dans une image minimale (`scratch`) avec les certificats CA pour les requêtes HTTPS.

### Build de l'image

```powershell
docker build -t quelpoke:latest .
```

### Exécution

```powershell
# Expose le port 8080 par défaut
docker run --rm -p 8080:8080 quelpoke:latest

# Optionnel: définir une version affichée dans la page
docker run --rm -e VERSION=1.0.0 -p 8080:8080 quelpoke:latest
```

L'application écoute par défaut sur `0.0.0.0:8080`. Vous pouvez surcharger:

- `PORT` (par défaut `8080`)
- `ADDR` (par défaut `0.0.0.0`)
- `VERSION` (affichée dans le titre)

Exemple:

```powershell
docker run --rm -e PORT=8080 -e ADDR=0.0.0.0 -e VERSION=prod -p 8080:8080 quelpoke:latest
```

Ensuite ouvrez http://localhost:8080 et entrez votre prénom.

## Développement local

```powershell
# Lancer localement (Go 1.22+)
go run .

# Build local
go build -o quelpoke .
```

Le template HTML `index.tmpl.html` est embarqué dans le binaire via `//go:embed`.

## Lancer avec Docker Compose

Un fichier `docker-compose.yml` est fourni.

```powershell
# Démarrer en arrière-plan
docker compose up -d

# Voir les logs
docker compose logs -f

# Arrêter
docker compose down
```

Variables d'environnement (peuvent être définies dans votre shell ou un fichier `.env`):

- `VERSION` (par défaut `dev`)
- `PORT` (par défaut `8080`)
- `ADDR` (par défaut `0.0.0.0`)

Exemple avec version personnalisée:

```powershell
$env:VERSION = "1.2.3"; docker compose up -d
```
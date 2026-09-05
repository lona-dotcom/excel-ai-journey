@echo off
echo =====================================================
echo   Configuration de l'environnement Excel-AI-Journey
echo =====================================================
echo.

:: 1. Vérifier si Python est installé
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Python n'est pas trouve dans le PATH.
    echo Veuillez installer Python depuis https://www.python.org/downloads/
    pause
    exit /b 1
)
echo [OK] Python est installe.

:: 2. Creation de l'environnement virtuel (.venv)
IF NOT EXIST ".venv" (
    echo [INFO] Creation de l'environnement virtuel...
    python -m venv .venv
) ELSE (
    echo [OK] L'environnement .venv existe deja.
)

:: 3. Activation de l'environnement
echo [INFO] Activation de l'environnement...
call .venv\Scripts\activate.bat

:: 4. Installation des dependances (requirements.txt)
IF EXIST "requirements.txt" (
    echo [INFO] Installation des bibliotheques Python...
    pip install --upgrade pip
    pip install -r requirements.txt
) ELSE (
    echo [ATTENTION] Le fichier requirements.txt est introuvable.
    echo [INFO] Generons-le automatiquement depuis votre environnement actuel...
    pip freeze > requirements.txt
)
echo [OK] Dependances installees.

:: 5. Creation du fichier .env (variables d'environnement)
IF NOT EXIST ".env" (
    echo [INFO] Creation du fichier .env...
    (
        echo # =========================================
        echo # Configuration du projet Excel-AI-Journey
        echo # =========================================
        echo.
        echo # Chemins des dossiers
        echo DATA_PATH=./data/raw
        echo OUTPUT_PATH=./data/processed
        echo.
        echo # Cles API (A REMPLIR par vous-meme !)
        echo OPENAI_API_KEY=VOTRE_CLE_ICI
        echo ANTHROPIC_API_KEY=VOTRE_CLE_ICI
        echo.
        echo # Configuration Git (Optionnel)
        echo GIT_USER_NAME=Votre Nom
        echo GIT_USER_EMAIL=votre@email.com
    ) > .env
    echo [OK] Fichier .env cree. Pensez a y mettre vos vraies cles API !
) ELSE (
    echo [OK] Le fichier .env existe deja.
)

:: 6. Initialisation de Git et configuration
IF NOT EXIST ".git" (
    echo [INFO] Initialisation du depot Git...
    git init
)
echo [INFO] Configuration de l'identite Git (si non definie globalement)...
:: Vérifie si le nom global est vide
git config --global user.name >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    :: Lit le nom depuis le .env (astuce simple sans lib externe)
    for /f "tokens=2 delims==" %%a in ('findstr "GIT_USER_NAME" .env') do set MY_NAME=%%a
    for /f "tokens=2 delims==" %%a in ('findstr "GIT_USER_EMAIL" .env') do set MY_EMAIL=%%a
    git config user.name "%MY_NAME%"
    git config user.email "%MY_EMAIL%"
    echo [OK] Identite Git locale configuree depuis .env.
) ELSE (
    echo [OK] Identite Git globale deja configuree.
)

:: 7. Creation de la structure des dossiers data
IF NOT EXIST "data\raw" mkdir data\raw
IF NOT EXIST "data\processed" mkdir data\processed
echo [OK] Structure de dossiers "data" verifiee.

:: Fin
echo.
echo =====================================================
echo   Configuration terminee avec succes !
echo   N'oubliez pas de remplir vos cles API dans .env
echo   Pour lancer le projet : .venv\Scripts\activate
echo =====================================================
pause
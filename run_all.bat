@echo off
:: Active l'environnement virtuel
call .venv\Scripts\activate.bat

echo =====================================================
echo   Environnement "Excel AI Journey" Active !
echo =====================================================
echo.
echo   [1] Lancer Jupyter Notebook (dans le dossier notebooks)
echo   [2] Ouvrir un terminal Python interactif
echo   [3] Quitter
echo.
set /p choice="Faites votre choix (1, 2 ou 3) : "

if "%choice%"=="1" (
    echo Lancement de Jupyter...
    jupyter notebook "notebooks"
) else if "%choice%"=="2" (
    echo Ouverture du terminal Python...
    python
) else (
    echo Fermeture du script.
    pause
)
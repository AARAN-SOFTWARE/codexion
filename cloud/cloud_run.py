# cloud_run.py

import typer
from dotenv import load_dotenv

app = typer.Typer()
load_dotenv()

@app.callback()
def main():
    typer.secho("Welcome to Codexion Cloud Manager", bold=True, fg=typer.colors.CYAN)

if __name__ == "__main__":
    app()

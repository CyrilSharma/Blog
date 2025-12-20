#!/usr/bin/env python3
from rich.console import Console
from rich.prompt import Prompt
import datetime
import os
import sys
import subprocess

console = Console()
BLOG_DIR = './content/article'

def iso_timestamp() -> str:
    """
    Return current local time (no microseconds) in ISO 8601 form with offset.
    E.g.: "2025-05-23T18:42:10-04:00"
    """
    now = datetime.datetime.now().astimezone().replace(microsecond=0)
    return now.isoformat()

def prompt_nonempty(prompt_text: str) -> str:
    """
    Prompt the user until they enter a non-empty string.
    """
    while True:
        response = Prompt.ask(prompt_text).strip()
        if response:
            return response
        console.print("[red]Input cannot be empty. Please try again.[/red]")

def create_new_typst_file():
    # Ask for filename
    while True:
        title = prompt_nonempty("[cyan]Enter title[/cyan]")
        filename = title.lower().replace(" ", "-")
        if os.path.exists(filename):
            console.print(f"[red]Error:[/red] '{title}' already exists. Please choose a different title.")
            continue
        break

    # Ask for title, description, tags
    description = "" # prompt_nonempty("[cyan]Enter short description[/cyan]")
    raw_tags = prompt_nonempty("[cyan]Enter comma-separated tags (e.g. evolution,notes)[/cyan]")

    # Build ISO timestamp string once
    timestamp = iso_timestamp()

    # Parse tags: split by comma, strip whitespace, wrap each in quotes
    tag_list = [tag.strip() for tag in raw_tags.split(",") if tag.strip()]
    if not tag_list:
        console.print("[red]Error:[/red] At least one tag is required.")
        sys.exit(1)
    tags_field = ", ".join(f"\"{t}\"" for t in tag_list)
    if len(tag_list) == 1:
        tags_field += ","

    # Construct the Typst content
    content = (
        '#import "/typ/templates/blog.typ": *\n'
        "#show: main.with(\n"
        f'  title: "{title}",\n'
        f'  desc: "{description}",\n'
        f'  date: "{timestamp}",\n'
        f'  tags: ({tags_field}),\n'
        ")\n"
    )

    # Write to file
    filepath = f"{BLOG_DIR}/{filename}.typ"
    try:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        console.print(f"\n✅ [green]Created new Typst file:[/green] [bold]{filename}[/bold]")
    except OSError as e:
        console.print(f"[red]Error writing file:[/red] {e}")
        sys.exit(1)


def main():
    console.print("\n[bold underline]Typst Blog Helper[/bold underline]\n")
    create_new_typst_file()

if __name__ == "__main__":
    main()

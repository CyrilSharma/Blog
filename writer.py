#!/usr/bin/env python3
from rich.console import Console
from rich.prompt import Prompt
from rich.text import Text
import datetime
import os
import sys

console = Console()

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

def main():
    console.print("\n[bold underline]Create a New Typst File[/bold underline]\n")
    console.print("This script will ask for the necessary information and create a `.typ` file")
    console.print("with a fixed creation timestamp.\n")

    # Ask for filename
    while True:
        filename = Prompt.ask("[cyan]Enter filename[/cyan]").strip()
        if os.path.exists(filename):
            console.print(f"[red]Error:[/red] '{filename}' already exists. Please choose a different name.")
            continue
        break

    # Ask for title, description, tags
    title = prompt_nonempty("[cyan]Enter title[/cyan]")
    description = prompt_nonempty("[cyan]Enter short description[/cyan]")
    raw_tags = prompt_nonempty("[cyan]Enter comma-separated tags (e.g. evolution,notes)[/cyan]")

    # Build ISO timestamp string once
    timestamp = iso_timestamp()

    # Parse tags: split by comma, strip whitespace, wrap each in quotes
    tag_list = [tag.strip() for tag in raw_tags.split(",") if tag.strip()]
    if not tag_list:
        console.print("[red]Error:[/red] At least one tag is required.")
        sys.exit(1)
    tags_field = ", ".join(f"\"{t}\"" for t in tag_list)

    # Construct the Typst content
    content = (
        '#import "/typ/templates/blog.typ": main\n'
        "#show: main.with(\n"
        f'  title: "{title}",\n'
        f'  desc: ["{description}"],\n'
        f'  date: "{timestamp}",\n'
        f'  tags: ({tags_field}),\n'
        ")\n"
    )

    # Write to file
    OUTPUT = './content/article'
    try:
        with open(f"{OUTPUT}/{filename}.typ", "w", encoding="utf-8") as f:
            f.write(content)
        console.print(f"\n✅ [green]Created new Typst file:[/green] [bold]{filename}[/bold]")
    except OSError as e:
        console.print(f"[red]Error writing file:[/red] {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

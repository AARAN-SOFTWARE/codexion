import os
import re
from jinja2 import Environment, FileSystemLoader

from prefiq import CPATH
from prefiq.utils.j2template_formater import postprocess_rendered

TEMPLATE_DIR = CPATH.PREFIQ_TEMPLATE  # Path object

def generate_from_template(template_name: str, output_filename: str, context: dict, output_dir: str):

    if not isinstance(context, dict):
        raise TypeError(f"Expected context to be dict, got {type(context).__name__}")

    env = Environment(loader=FileSystemLoader(str(TEMPLATE_DIR)))  # <- fix here
    template = env.get_template(template_name)

    rendered = template.render(context)
    final_output = postprocess_rendered(rendered)

    output_path = os.path.join(output_dir, output_filename)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    print(f"[DEBUG] Final write path: {output_path}")

    with open(output_path, "w") as f:
        f.write(final_output)


def generate_template_to_string(template_name: str, context: dict = None) -> str:
    context = context or {}
    env = Environment(loader=FileSystemLoader(str(TEMPLATE_DIR)))  # <- fix here too
    template = env.get_template(template_name)

    rendered = template.render(context)

    # Inline postprocess for quick use
    rendered = re.sub(r"@@B@@", "\n", rendered)
    rendered = re.sub(r"{#(?!\.r).*?#}", "", rendered, flags=re.DOTALL)

    return rendered.strip()

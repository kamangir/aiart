# 🎨 aiart (`articraft`)

🎨 `aiart` is an interface to [OpenAI commands](https://github.com/kamangir/openai-commands), [DALL-E](https://github.com/kamangir/openai-commands/blob/main/.abcli/DALLE.sh), [stable diffusion](https://github.com/kamangir/blue-stability), and [ComfyUI](https://github.com/comfyanonymous/ComfyUI). `aiart` can ingest [text and poetry](https://github.com/kamangir/aiart/blob/main/aiart/html/functions.py) from [allpoetry.com](https://allpoetry.com/), [medium](https://medium.com/), and [poetryfoundation.org](https://www.poetryfoundation.org/).

```bash
pip install articraft
```

🔷 [ComfyUI](#ComfyUI) 🔷 [`aiart`](#aiart) 🔷 [APIs](./APIs.yaml) 🔷

---

## ComfyUI

start [ComfyUI](./articraft/.abcli/ComfyUI.sh) [on SageMaker](https://github.com/kamangir/blue-plugin/blob/main/SageMaker.md) then follow [these instructions](https://medium.com/@dminhk/3-easy-steps-to-run-comfyui-on-amazon-sagemaker-notebook-c9bdb226c15e).

## aiart

```bash
 > aiart help
aiart generate image \
	[app=blue_stability|openai_commands,~dryrun,height=<576>,~sign,~tag,width=<768>] \
	[<image>] [<previous-image>] \
	["<prompt>"] \
	[-]
 . <prompt> -[<previous-image>]-> <image>.png.
```

| [stable diffusion](https://github.com/kamangir/blue-stability)                                   |                                                                                                 | [OpenAI commands](https://github.com/kamangir/openai-commands)                                    |                                                                                                  | [DALL-E](https://github.com/kamangir/openai-commands/blob/main/.abcli/DALLE.sh)        |
| ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| ![image](https://raw.githubusercontent.com/kamangir/blue-stability/main/assets/carrot.png?raw=1) | ![image](https://raw.githubusercontent.com/kamangir/blue-stability/main/assets/minds.gif?raw=1) | ![image](https://raw.githubusercontent.com/kamangir/openai-commands/main/assets/carrot.png?raw=1) | ![image](https://raw.githubusercontent.com/kamangir/openai-commands/main/assets/minds.gif?raw=1) | ![image](https://github.com/kamangir/openai-commands/raw/main/assets/DALL-E.png?raw=1) |

---

[![PyPI version](https://img.shields.io/pypi/v/articraft.svg)](https://pypi.org/project/articraft/)

an 🚀 [`awesome-bash-cli`](https://github.com/kamangir/awesome-bash-cli) (`abcli`) plugin.

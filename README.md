# aiart (articraft)

🎨 `aiart` is an interface to [OpenAI commands](https://github.com/kamangir/openai-commands), [DALL-E](https://github.com/kamangir/openai-commands/blob/main/.abcli/DALLE.sh), and [Stable Diffusion](https://github.com/kamangir/blue-stability). AiArt can ingest [text and poetry](https://github.com/kamangir/aiart/blob/main/aiart/html/functions.py) from [allpoetry.com](https://allpoetry.com/), [medium](https://medium.com/), and [poetryfoundation.org](https://www.poetryfoundation.org/).

🔷 [APIs](./APIs.yaml) 🔷

```bash
abcli_quote <message>
 . urllib.parse.quote(<message>).
abcli_unquote <message>
 . urllib.parse.unquote(<message>).
aiart generate image \
	[app=blue_stability|openai_commands,~dryrun,height=<576>,~sign,~tag,width=<768>] \
	[<image>] [<previous-image>] \
	["<prompt>"] \
	[-]
 . <prompt> -[<previous-image>]-> <image>.png.
aiart generate video \
	[app=blue_stability|openai_commands,~dryrun,frame_count=16,marker=PART,~publish,~render,resize_to=1280x1024,~sign,slice_by=words|sentences,~upload,url] \
	<filename.txt|url> \
	[-]
 . <filename.txt>|url -> video.mp4
aiart generate validate \
	[app=blue_stability|openai_commands,dryrun,what=all|image|video]
 . validate aiart.
aiart html ingest_url \
	<url> \
	[--fake_agent 1] \
	[--verbose 1]
 . ingest <url>.
aiart publish \
	[generator=blue_stability|DALL-E|openai_commands]
 . publish 2024-05-22-07-37-34-67918.
aiart transform \
	[count=<1>,~dryrun,extension=jpg,~sign,~tag,~upload] \
	[<object-name>] \
	["<prompt>"] \
	[-]
 . <object-name> -<prompt>-> 2024-05-22-07-37-34-67918.
```

| [Stable Diffusion](https://github.com/kamangir/blue-stability)                                   | [OpenAI commands](https://github.com/kamangir/openai-commands)                                    |
| ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| ![image](https://raw.githubusercontent.com/kamangir/blue-stability/main/assets/carrot.png?raw=1) | ![image](https://raw.githubusercontent.com/kamangir/openai-commands/main/assets/carrot.png?raw=1) |
| ![image](https://raw.githubusercontent.com/kamangir/blue-stability/main/assets/minds.gif?raw=1)  | ![image](https://raw.githubusercontent.com/kamangir/openai-commands/main/assets/minds.gif?raw=1)  |

| [DALL-E](https://github.com/kamangir/openai-commands/blob/main/.abcli/DALLE.sh)        |
| -------------------------------------------------------------------------------------- |
| ![image](https://github.com/kamangir/openai-commands/raw/main/assets/DALL-E.png?raw=1) |

an [`awesome-bash-cli`](https://github.com/kamangir/awesome-bash-cli) (`abcli`) plugin.

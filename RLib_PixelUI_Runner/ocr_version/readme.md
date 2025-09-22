# RLib_PixelRunner

RLib的像素脚本执行器


clone后，右键目录，选择`在终端中打开`

```powershell

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"


uv python install 3.11.13

uv sync

uv run .\main.py

```


## 编译

```

uv run .\deploy.py


```

然后创建`build\main.dist\ddddocr`目录，将`common_old.onnx`、`common_det.onnx`、`common.onnx`复制到该目录内

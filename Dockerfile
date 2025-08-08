# -----------------------------------------------------------------------------
# Imagen base con Python 3.9 slim
# -----------------------------------------------------------------------------
FROM python:3.9-slim

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------------------------
# 1) Dependencias de sistema
#    - tk para jhwutils
#    - librerías de imagen y audio
# -----------------------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-tk tk-dev tcl-dev \     
    libsm6 libxext6 libxrender-dev \  
    ffmpeg libavcodec-extra \        
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 2) PyTorch, torchvision, torchaudio, torchtext "legacy", CUDA 11.1
# -----------------------------------------------------------------------------
RUN pip install --no-cache-dir \
    torch==1.9.0+cu111 \
    torchvision==0.10.0+cu111 \
    torchaudio==0.9.0 \
    torchtext==0.10.0 \
    -f https://download.pytorch.org/whl/cu111/torch_stable.html

# -----------------------------------------------------------------------------
# 3) Resto de las librerías Python del laboratorio
# -----------------------------------------------------------------------------
RUN pip install --no-cache-dir \
    jupyter \
    "numpy<2" \
    scipy \
    matplotlib \
    scikit-image \
    pillow \
    spacy \
    nltk \
    datasets

# -----------------------------------------------------------------------------
# 4) Instalar jhwutils y lautils desde GitHub (forzar reinstalación)
# -----------------------------------------------------------------------------
RUN pip install -U --force-reinstall --no-cache \
    https://github.com/johnhw/jhwutils/zipball/master \
    https://github.com/AlbertS789/lautils/zipball/master

# -----------------------------------------------------------------------------
# 5) Descargar modelos de spaCy
# -----------------------------------------------------------------------------
RUN python -m spacy download en_core_web_sm && \
    python -m spacy download de_core_news_sm

# -----------------------------------------------------------------------------
# 6) Configuración de usuario y puerto
# -----------------------------------------------------------------------------
WORKDIR /lab
VOLUME /lab

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", \
     "--NotebookApp.token=''", "--NotebookApp.password=''"]

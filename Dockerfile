FROM featureoverload/uvicorn-gunicorn-fastapi:python3.9

# Setup Pypi
ARG PyPI_CN_HOST=pypi.doubanio.com
ARG PyPI_CN_REPO=https://${PyPI_CN_HOST}/simple
#ARG PyPI_PRI_HOST=pypi.private.com
#ARG PyPI_PRI_REPO=http://${PyPI_PRI_HOST}/root/public/+simple

RUN echo "[global]" > /etc/pip.conf \
 && echo "index-url = ${PyPI_CN_REPO}" >> /etc/pip.conf \
# && echo "extra-index-url = ${PyPI_PRI_REPO}" >> /etc/pip.conf \
 && echo "[install]" >> /etc/pip.conf \
 && echo "trusted-host = ${PyPI_CN_HOST}" >> /etc/pip.conf \
# && echo "               ${PyPI_PRI_HOST}" >> /etc/pip.conf \
 && python -m pip install -U pip \
 && python -m pip install wheel
ENV TZ=Asia/Shanghai


WORKDIR /app/

# For development, Jupyter remote kernel, Hydrogen
# Using inside the container:
# jupyter lab --ip=0.0.0.0 --allow-root --NotebookApp.custom_display_url=http://127.0.0.1:8888
ARG INSTALL_JUPYTER=false
RUN bash -c "if [ $INSTALL_JUPYTER == 'true' ] ; then python3 -m pip install jupyterlab ; fi"

COPY requirements_test.txt /app/requirements_test.txt
# Allow installing test dependencies to run tests
ARG INSTALL_TEST=false
RUN bash -c "if [ $INSTALL_TEST == 'true' ] ; then python3 -m pip install -r requirements_test.txt; fi"

COPY requirements.txt /app/requirements.txt
RUN python3 -m pip install -r requirements.txt

# development configurations, like: "[tool.pytest.ini_options]", etc...
COPY ./pyproject.toml /app/pyproject.toml

COPY ./app /app/app
ENV PYTHONPATH=/app

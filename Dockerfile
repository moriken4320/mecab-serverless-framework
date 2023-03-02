FROM public.ecr.aws/lambda/python:3.9

RUN yum update -y \
    && yum install -y gcc-c++ python3-devel

# setup python
COPY ./requirements.txt /opt/
RUN pip install --upgrade pip && pip install -r /opt/requirements.txt

# set function code
WORKDIR /var/task
COPY lambda_function.py .
CMD ["lambda_function.lambda_handler"]

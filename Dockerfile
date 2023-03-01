FROM public.ecr.aws/lambda/python:3.8

RUN yum update -y

# setup python
COPY ./requirements.txt /opt/
RUN pip install --upgrade pip && pip install -r /opt/requirements.txt

# set function code
WORKDIR /var/task
COPY app.py .
CMD ["app.lambda_handler"]

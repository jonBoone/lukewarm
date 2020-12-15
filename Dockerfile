FROM debian

# Prepare image and install dependencies
ENV LANG=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y flex bison build-essential \
    csh libxaw7-dev wget \
    libc6-i386 default-jdk

# Install student dist

# Note that this is _not_ what is in the `/usr/class/cs143` subdirectory in the
# VM! The `cs143` contains make files that generate the assignments in an
# arbitrary folder from skeleton files. Essentially this step was already done
# in the `student-dist.tar.gz`. The assignments just have to be completed and
# submitted in the respective /class/assignments/PA* subdirectories.

# Prepare the immutable distribution
RUN mkdir -p /usr/class \
  && wget https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz -P /tmp \
  && tar xzf "/tmp/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@student-dist.tar.gz" -C /usr/class
ENV PATH=/usr/class/bin:$PATH

# Download submission scripts
RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa1-grading.pl \
  | tee /usr/class/assignments/PA2J/grade.pl /usr/class/assignments/PA2/grade.pl > /dev/null

RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa2-grading.pl \
  | tee /usr/class/assignments/PA3J/grade.pl /usr/class/assignments/PA3/grade.pl > /dev/null

RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa3-grading.pl \
  | tee /usr/class/assignments/PA4J/grade.pl /usr/class/assignments/PA4/grade.pl > /dev/null

RUN wget -O - https://courses.edx.org/asset-v1:StanfordOnline+SOE.YCSCS1+1T2020+type@asset+block@pa4-grading.pl \
  | tee /usr/class/assignments/PA5J/grade.pl /usr/class/assignments/PA5/grade.pl > /dev/null

# Setup working directory
RUN mkdir -p /class
WORKDIR /class

# Run entrypoint to connect working directory to mounted host volume
COPY entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/bash"]

FROM containers.intersystems.com/intersystems/iris-community:2023.1

COPY app app
COPY iris.script iris.script

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly

ENV ISC_CPF_MERGE_FILE=$ISC_PACKAGE_INSTALLDIR/merge.cpf
COPY merge.cpf $ISC_PACKAGE_INSTALLDIR

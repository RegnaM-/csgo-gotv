FROM ubuntu:16.04
MAINTAINER Max Gonzih <gonzih at gmail dot com>

ENV USER csgo
ENV HOME /home/$USER
ENV SERVER $HOME/hlserver

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install lib32gcc1 curl net-tools lib32stdc++6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd $USER \
    && mkdir $HOME \
    && chown $USER:$USER $HOME \
    && mkdir $SERVER

ADD ./csgo_ds.txt $SERVER/csgo_ds.txt
ADD ./update.sh $SERVER/update.sh
ADD ./csgo.sh $SERVER/csgo.sh
RUN mkdir /$HOME/.steam/sdk32
RUN ln -s /$SERVER/steamcmd/linux32/steamclient.so /$HOME/.steam/sdk32/steamclient.so

RUN chown -R $USER:$USER $SERVER

USER $USER
RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz \
 && $SERVER/update.sh
RUN cp $SERVER/steamcmd.sh $SERVER/steam.sh
RUN chmod +x $SERVER/steam.sh

WORKDIR /home/$USER/hlserver
CMD ["./csgo.sh"]

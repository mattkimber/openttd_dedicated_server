FROM debian:buster
MAINTAINER Matt Kimber <matt@mattkimber.co.uk>

# Install OpenTTD release
RUN apt-get update && \
    apt-get install -y wget libsdl2-2.0-0 libfontconfig1 libfreetype6 libicu63 liblzo2-2 libpng16-16 unzip && \
    wget https://cdn.openttd.org/openttd-releases/1.10.0-RC1/openttd-1.10.0-RC1-linux-debian-buster-amd64.deb && \
    dpkg -i openttd-1.10.0-RC1-linux-debian-buster-amd64.deb

# Install the base graphics set
RUN wget https://cdn.openttd.org/opengfx-releases/0.5.5/opengfx-0.5.5-all.zip && \
    unzip opengfx-0.5.5-all.zip && \
    mv opengfx-0.5.5.tar /usr/share/games/openttd/baseset

# Add necessary newgrf files (OpenTTD won't install on start, needs console commands)
WORKDIR /usr/share/games/openttd/content_download/newgrf

RUN wget http://binaries.openttd.org/bananas/newgrf/av8_Aviators_Aircraft_Set-2.21.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/CHIPS_Station_Set-1.9.0.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/FIRS_Industry_Replacement_Set_3-3.0.12.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/Industrial_Stations_Renewal-1.0.2.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/Iron_Horse_2-2.5.0.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/FISH_2-2.0.3.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/Timberwolfs_UK_Road_Vehicles-46.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/Dutch_Stations_Set-1.0.0alpha.tar.gz && \
    wget http://binaries.openttd.org/bananas/newgrf/Estonian_Town_Names-1.0.01.tar.gz && \
    gunzip *

# Add game script
WORKDIR /usr/share/games/openttd/content_download/game

RUN wget http://binaries.openttd.org/bananas/gamescript/Villages_Is_Villages-9.tar.gz && \
    gunzip *

WORKDIR /usr/share/games/openttd/content_download/game/library

RUN wget http://binaries.openttd.org/bananas/gslibrary/SuperLib_for_NoGo-40.tar.gz && \
    wget http://binaries.openttd.org/bananas/gslibrary/Graph.AyStar-6-2.tar.gz && \
    wget http://binaries.openttd.org/bananas/gslibrary/Pathfinder.Road-4-2.tar.gz && \
    wget http://binaries.openttd.org/bananas/gslibrary/Queue.BinaryHeap-1-2.tar.gz && \
    gunzip *

# Clean up
WORKDIR /

RUN rm openttd-1.10.0-RC1-linux-debian-buster-amd64.deb && \
    rm opengfx-0.5.5-all.zip

COPY src/openttd.cfg /usr/share/games/openttd/openttd.cfg

EXPOSE 3979/tcp
EXPOSE 3979/udp

STOPSIGNAL 3

CMD [ "/usr/games/openttd",  "-D" ]

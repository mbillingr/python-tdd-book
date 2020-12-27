
run-server: prosody-0.11.7/prosody.cfg.lua.install prosody-0.11.7/prosody.cfg.lua
	echo "running server"
	cd prosody-0.11.7; \
	lua5.3 prosody

prosody-0.11.7.tar.gz:
	echo "downloading..."
	curl -O https://prosody.im/downloads/source/prosody-0.11.7.tar.gz
	echo "... downloaded"

prosody-0.11.7/prosody: prosody-0.11.7.tar.gz
	tar xzvf prosody-0.11.7.tar.gz
	echo "... unpacked"

prosody-0.11.7/config.unix: prosody-0.11.7/prosody
	cd prosody-0.11.7; \
	./configure --lua-version=5.3 --with-lua-include=/usr/include/lua5.3
	echo "... configured"

prosody-0.11.7/prosody.cfg.lua.install: prosody-0.11.7/config.unix
	cd prosody-0.11.7; make
	echo "... made"

prosody-0.11.7/prosody.cfg.lua: prosody.cfg.lua
	cp $< $@
	echo "... cfg'd"


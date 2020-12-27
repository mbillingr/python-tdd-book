
run-server: prosody-0.11.7/accounts-created prosody-0.11.7/prosody.cfg.lua
	echo "running server"
	cd prosody-0.11.7; \
	lua5.3 prosody

prosody-0.11.7/accounts-created: prosody-0.11.7/prosody.cfg.lua.install prosody-0.11.7/prosody.cfg.lua
	cd prosody-0.11.7; \
	lua5.3 prosodyctl register sniper localhost sniper; \
	lua5.3 prosodyctl register auction-item-54321 localhost auction; \
	lua5.3 prosodyctl register auction-item-65432 localhost auction; \
	touch accounts-created

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


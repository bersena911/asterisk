from urllib.parse import urljoin

import requests

from schemas import PJSipUserData


class AsteriskClient:

    def __init__(self, host: str, user: str, password: str):
        self.host = host
        self.asterisk_auth = (user, password)

    @staticmethod
    def convert_data_to_asterisk_fields(data: dict) -> dict:
        fields = []
        for key, value in data.items():
            fields.append({"attribute": key, "value": value})
        return {"fields": fields}


class PJSipClient(AsteriskClient):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.pjsip_url = urljoin(self.host, "ari/asterisk/config/dynamic/res_pjsip/")

    def create_auth(self, user_data: PJSipUserData):
        auth_data = {
            "auth_type": "userpass"
        }
        auth_data.update(user_data.dict())
        auth_url = urljoin(self.pjsip_url, f"auth/{user_data.username}")
        auth_create_response = requests.put(
            auth_url,
            json=self.convert_data_to_asterisk_fields(auth_data),
            auth=self.asterisk_auth
        )
        return auth_create_response

    def create_aor(self, user_data: PJSipUserData):
        aor_data = {
            "max_contacts": "1",
            "remove_existing": "yes",
            "remove_unavailable": "yes",
        }
        aor_url = urljoin(self.pjsip_url, f"aor/{user_data.username}")
        aor_create_response = requests.put(
            aor_url,
            json=self.convert_data_to_asterisk_fields(aor_data),
            auth=self.asterisk_auth
        )
        return aor_create_response

    def create_endpoint(self, user_data: PJSipUserData):
        endpoint_data = {
            "context": "transporte",
            "disallow": "all",
            "allow": "opus,ulaw,alaw",
            "direct_media": "no",
            "force_rport": "yes",
            "ice_support": "yes",
            "auth": user_data.username,
            "aors": user_data.username,
        }
        endpoint_url = urljoin(self.pjsip_url, f"endpoint/{user_data.username}")
        endpoint_create_response = requests.put(
            endpoint_url,
            json=self.convert_data_to_asterisk_fields(endpoint_data),
            auth=self.asterisk_auth
        )
        return endpoint_create_response

    def create_user(self, user_data: PJSipUserData):
        pjsip_funcs = [self.create_auth, self.create_aor, self.create_endpoint]
        for pjsip_func in pjsip_funcs:
            response = pjsip_func(user_data)
            if not response.ok:
                raise Exception(f"User creation failed: {user_data.username}")
        return {"status": "ok"}

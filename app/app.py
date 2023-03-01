from fastapi import FastAPI

from asterisk_client import PJSipClient
from schemas import PJSipUserData

app = FastAPI()

pjsip_client = PJSipClient(host="http://voip:8088", user="asterisk", password="asterisk")


@app.post("/users")
def create_user(pjsip_user_data: PJSipUserData):
    a = {
        "fields": [
            {"attribute": "from_user", "value": "alice"}, {"attribute": "allow", "value": "!all,g722,ulaw,alaw"},
            {"attribute": "ice_support", "value": "yes"}, {"attribute": "force_rport", "value": "yes"},
            {"attribute": "rewrite_contact", "value": "yes"}, {"attribute": "rtp_symmetric", "value": "yes"},
            {"attribute": "context", "value": "default"}, {"attribute": "auth", "value": "alice"},
            {"attribute": "aors", "value": "alice"}
        ]
    }

    return pjsip_client.create_user(user_data=pjsip_user_data)

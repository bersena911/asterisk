from pydantic import BaseModel


class PJSipUserData(BaseModel):
    username: str
    password: str

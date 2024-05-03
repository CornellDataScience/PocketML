from sqlmodel import Field, Relationship, SQLModel
from pydantic import BaseModel


class User(SQLModel, table=True):
    email: str = Field(default="un@defin.ed",
                       primary_key=True, unique=True, index=True)
    name: str = Field(default="undefined")
    # token: str = Field(nullable=False)
    email_notif: bool = Field(default=True)
    firebase_uid: str = Field(nullable=False)

    # TODO REMOVE THIS
    password: str = Field(nullable=False)

    jobs: list["Job"] = Relationship(back_populates="user")

    is_authenticated: bool = Field(default=False)
    is_admin: bool = Field(default=False)


class UserCreate(BaseModel):
    email: str
    name: str
    password: str
    email_notif: bool


class UserUpdate(BaseModel):
    name: str
    email_notif: bool


class UserLogin(BaseModel):
    email: str
    password: str


class Job(SQLModel, table=True):
    name: str = Field(primary_key=True, unique=True,
                      index=True, nullable=False)
    user_email: str = Field(foreign_key="user.email", nullable=False)
    user: User = Relationship(back_populates="jobs")

    wandb: bool = Field(nullable=False)
    wandb_link: str = Field(nullable=False)
    start_time: str = Field(nullable=False)
    cluster_name: str = Field(nullable=False)

    # TODO: in the future use better data storage
    config: dict = Field(nullable=False)

    current_step: int = Field(default=0)
    current_status: str = Field(default="stopped")
    last_update_time: str = Field(default="undefined")


class JobCreate(BaseModel):
    name: str
    wandb: bool
    wandb_link: str
    start_time: str
    config: dict
    cluster_name: str


class JobUpdate(BaseModel):
    name: str
    config: dict
    current_step: int
    current_status: str
    last_update_time: str

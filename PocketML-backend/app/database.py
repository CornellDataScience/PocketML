from sqlmodel import Session, create_engine, select
from config import settings

engine = create_engine(str(settings.DATABASE_URL))

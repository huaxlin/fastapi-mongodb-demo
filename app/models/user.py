from typing import Optional

from odmantic import Model

# if TYPE_CHECKING:
#     from .item import Item  # noqa: F401


class User(Model):
    full_name: Optional[str]
    email: str
    hashed_password: str
    is_active: bool = True
    is_superuser: bool = False
    # items = relationship("Item", back_populates="owner")

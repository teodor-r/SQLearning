select "bookA", "bookB", count(*), avg("ForkWL"."Percent")
from "ForkWL"
group  by ("bookA", "bookB")
order by "bookA"



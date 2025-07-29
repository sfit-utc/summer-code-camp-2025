import pandas as pd
import random
import numpy as np

first_names = ["Nguyen", "Tran", "Le", "Pham", "Hoang", "Luong", "Dinh"]
middle_names = ["Van", "Thi", "Khac", "Tuan", "Minh", "Duc", "Duy"]
last_names = ["Anh", "Hung", "Trang", "Hien", "Hang", "Dung", "Hoang", "Manh"]

data = {
    "ID": list(range(1, 101)),
    "Name": [f"{random.choice(first_names)} {random.choice(middle_names)} {random.choice(last_names)}" for _ in range(100)],
    "Mark": [random.choice([random.randint(0, 10), np.nan]) for _ in range(100)],
    "Sex": [random.choice(["Nam", "Nu", np.nan]) for _ in range(100)],
    "Age": [random.choice([random.randint(18, 25), np.nan]) for _ in range(100)]
}

my_df = pd.DataFrame(data)
my_df = my_df.sample(frac=1).reset_index(drop=True)
my_df.to_csv("students.csv", index=False)
print(my_df)

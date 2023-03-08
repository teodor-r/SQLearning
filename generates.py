import random
def generate_id ():
    alpha = 'qwertyuiopasdfghjklzxcvbnm'
    alpha = alpha + alpha.upper()
    alpha = alpha + '0123456789_.-'
    length = random.randint(5, 14)
    alphalen = len(alpha)
    id = ''
    for _ in range(length):
        idx = random.randint(0, alphalen-1)
        id = id + alpha[idx]
    return id
print(generate_id())


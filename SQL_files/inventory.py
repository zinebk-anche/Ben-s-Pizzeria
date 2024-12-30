import pandas as pd


# Provided data
data = {
    'ingredient_name': [
        'Anchovies', 'Banoffee pie', 'Caesar dressing', 'Calamari', 'Capers', 'Chicken wings',
        'Chilli pepper', 'Chocolate brownie', 'Chocolate ice cream', 'Coca Cola Diet 1.5l',
        'Coca Cola Diet 33cl', 'Coca Cola Regular 1.5l', 'Coca Cola Regular 33cl', 'Croutons',
        'Dried oregano', 'Eggplant', 'Fruit salad', 'Garlic and parsley butter', 'Gorgonzola cheese',
        'Ham', 'Mozzarella cheese', 'Parmesan cheese', 'Pepperoni', 'Pineapple', 'Pistachio ice cream',
        'Pizza dough ball (8 pack)', 'Ricotta cheese', 'Romain lettuce', 'Rotisserie chicken pieces',
        'Shrimp', 'Spicy salami', 'Sprite Regular 1.5l', 'Sprite Regular 33cl', 'Strawberry ice cream',
        'Tomato sauce', 'Tuna', 'Vanilla ice cream'
    ],
    'ordered_weight': [
        28900, 18960, 3380, 51925, 2300, 12480, 4690, 11400, 17000, 160, 187, 178, 133, 8450,
        2303, 40650, 24900, 2205, 48960, 39550, 479380, 104760, 61360, 31120, 21200, 785500,
        48960, 16900, 20280, 51925, 22510, 176, 133, 15500, 233120, 51925, 15500
    ],
    'total_inv_weight': [
        2000, 2400, 19000, 7500, 2000, 24000, 4000, 5000, 9000, 120, 120, 120, 120, 6250,
        2000, 20000, 10000, 9000, 35000, 20000, 100000, 25000, 25000, 20000, 9000, 100000,
        15000, 37500, 25000, 10000, 7000, 120, 120, 9000, 112500, 6000, 9000
    ]
}

df = pd.DataFrame(data)

# Calculate adjusted total inventory weight
df['target_remaining_weight'] = df['ordered_weight'] * 0.1  # 10% surplus
df['adjusted_total_inv_weight'] = df['ordered_weight'] + \
    df['target_remaining_weight']

# Display the result
df[['ingredient_name', 'ordered_weight',
    'total_inv_weight', 'adjusted_total_inv_weight']].head()

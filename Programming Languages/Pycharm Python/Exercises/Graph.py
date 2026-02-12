
import matplotlib.pyplot as plt
import numpy as np

# Physical constants
e = 1.602e-19        # Charge of an electron (C)
epsilon_0 = 8.854e-12 # Permittivity of free space (F/m)

# Function to calculate Kinetic Energy
def calculate_ke(lambda_val):
    return (e * lambda_val) / (4 * np.pi * epsilon_0)

# Generate linear charge density values (lambda) from 0 to 10e-9 C/m
lambda_values = np.linspace(0, 10e-9, 100)
ke_values = calculate_ke(lambda_values)

# Plotting
plt.figure(figsize=(8, 5))
plt.plot(lambda_values, ke_values, color='blue', linewidth=2)

# Formatting the graph
plt.title('Kinetic Energy of Electron vs. Linear Charge Density', fontsize=12)
plt.xlabel('Linear Charge Density $\lambda$ (C/m)', fontsize=10)
plt.ylabel('Kinetic Energy (Joules)', fontsize=10)
plt.grid(True, linestyle='--', alpha=0.7)
plt.ticklabel_format(style='sci', axis='both', scilimits=(0,0))

# Display the plot
plt.show()

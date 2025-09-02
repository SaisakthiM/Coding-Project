import numpy as np
import plotly.graph_objects as go

# Parameters (tweak these)
R = 1.0       # center radius
a = 0.01      # half-width scale (small to avoid self-intersections)
w = 1.0       # parameter domain half-width (v in [-w,w])
nu, nv = 220, 40

u = np.linspace(0, 2*np.pi, nu)
v = np.linspace(-w, w, nv)
U, V = np.meshgrid(u, v)

# prepare traces for several n values
ns = list(range(1, 7))  # n from 1 to 6
surfaces = []
for n in ns:
    X = (R + a * V * np.cos(n * U / 2.0)) * np.cos(U)
    Y = (R + a * V * np.cos(n * U / 2.0)) * np.sin(U)
    Z = a * V * np.sin(n * U / 2.0)
    surf = go.Surface(x=X, y=Y, z=Z, showscale=False, opacity=0.95,
                      hoverinfo='skip', name=f'n={n}')
    surfaces.append(surf)

# build figure with all surfaces but only show the first initially
fig = go.Figure(data=surfaces)

# make only the first visible
for i, d in enumerate(fig.data):
    d.visible = (i == 0)

# Buttons to toggle which n is visible
updatemenus = [
    dict(
        type="buttons",
        direction="right",
        x=0.1, y=1.15,
        showactive=True,
        buttons=[
            dict(label=f"n={n}",
                 method="update",
                 args=[{"visible": [i==j for j in range(len(ns)) for i in [j]]},  # weird but works
                       {"title": f"n = {n} (half-twists)"}])
            for n in ns
        ],
    )
]

# A corrected generation of visibility lists for each button:
vis_lists = []
for idx in range(len(ns)):
    vis = [False]*len(ns)
    vis[idx] = True
    vis_lists.append(vis)

# Rebuild buttons properly
buttons = []
for n, vis in zip(ns, vis_lists):
    buttons.append(dict(label=f"n={n}",
                        method="update",
                        args=[{"visible": vis},
                              {"title": f"n = {n} (half-twists)"}]))
fig.update_layout(
    updatemenus=[dict(buttons=buttons, direction="right", x=0.05, y=1.15)],
    title=f"n = {ns[0]} (half-twists)",
    width=900, height=700,
)

# Visual tuning
fig.update_scenes(aspectmode='auto')
fig.update_layout(margin=dict(l=0, r=0, t=80, b=0))

fig.show()

from nnv import NNV

# Let's increase the size of the plot
import matplotlib.pyplot as plt
plt.rcParams["figure.figsize"] = (200,10)


layers_list = [
    {"title":"input\n(relu)", "units": 300, "color": "darkBlue"},
    {"title":"hidden 1\n(relu)", "units": 150},
    {"title":"hidden 2\n(relu)",  "units": 75},
    {"title":"Dropout\n(0.5)", "units": 75, "color":"lightGray"},
    {"title":"hidden 4\n(relu)",  "units": 18},
    {"title":"hidden 5\n(relu)",  "units": 9},
    {"title":"hidden 6\n(relu)",  "units": 4},
    {"title":"output\n(sigmoid)", "units": 1, "color": "darkBlue"},
]


NNV(layers_list, max_num_nodes_visible=8, node_radius=10, spacing_layer=60, font_size=24).render(save_to_file="my_example_2.pdf")
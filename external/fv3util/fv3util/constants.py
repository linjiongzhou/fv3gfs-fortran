MASTER_RANK = 0
X_DIM = 'x'
X_INTERFACE_DIM = 'x_interface'
Y_DIM = 'y'
Y_INTERFACE_DIM = 'y_interface'
Z_DIM = 'z'
Z_INTERFACE_DIM = 'z_interface'
HORIZONTAL_DIMS = (X_DIM, X_INTERFACE_DIM, Y_DIM, Y_INTERFACE_DIM)

LEFT = 'left'
RIGHT = 'right'
TOP = 'top'
BOTTOM = 'bottom'
TOP_LEFT = 'top_left'
TOP_RIGHT = 'top_right'
BOTTOM_LEFT = 'bottom_left'
BOTTOM_RIGHT = 'bottom_right'
EDGE_BOUNDARY_TYPES = (TOP, BOTTOM, LEFT, RIGHT)
CORNER_BOUNDARY_TYPES = (TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT)
BOUNDARY_TYPES = EDGE_BOUNDARY_TYPES + CORNER_BOUNDARY_TYPES

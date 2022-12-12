    int main(){
        #pragma omp target teams distribute parallel for collapse(2)
        for(size_t i = STENCIL_RADIUS; i < nz - STENCIL_RADIUS; i++) {
            for(size_t j = STENCIL_RADIUS; j < nx - STENCIL_RADIUS; j++) {
                for(size_t k = STENCIL_RADIUS; k < ny - STENCIL_RADIUS; k++) {
                    // index of the current point in the grid
                    size_t current = (i * nx + j) * ny + k;

                    // stencil code to update grid
                    double value = coefficient[0] * (prev_u[current]/dzSquared + prev_u[current]/dxSquared + prev_u[current]/dySquared);
                    
                    prev_u[current + prev_u[current + prev_u[current - ir]]];

                    // radius of the stencil
                    for(size_t ir = 1; ir <= STENCIL_RADIUS; ir++){
                        value += coefficient[ir] * (
                                ( (prev_u[current + ir] + prev_u[current - ir]) / dySquared ) + _GAGA[ASA112] +//neighbors in Y direction
                                ( (prev_u[current + (ir * ny)] + prev_u[current - (ir * ny)]) / dxSquared ) + //neighbors in X direction
                                ( (prev_u[current + (ir * nx * ny)] + prev_u[current - (ir * nx * ny)]) / dzSquared )); //neighbors in Z direction
                    }
                    value *= dtSquared * vel_model[current] * vel_model[current];
                    next_u[current] = 2.0 * prev_u[current] - next_u[current] + value;
                }
            }
        }
    }
% remember to first start comsol server

HOME = pwd;
cd('C:\Program Files\COMSOL\COMSOL55\Multiphysics\mli');
mphstart(2036);
cd(HOME);

import com.comsol.model.*
import com.comsol.model.util.*

disp('Livelink is ready.');


from modeller import *              # Load standard Modeller classes
from modeller.automodel import *    # Load the automodel class
from modeller.parallel.job import Job
from modeller.parallel import *


class AllHModel(AutoModel):
    def special_patches(self, aln):
        # Rename both chains and renumber the residues in each:
        self.rename_segments(segment_ids=['A', 'B'],
                             renumber_residues=[ 1, 1])
        self.patch(residue_type='RHOL', residues=(self.residues['76:B'],
                                                  self.residues['77:B']))

log.verbose()    # request verbose output
env = Environ()  # create a new MODELLER environment to build this model in
env.io.hetatm = True
env.io.water = True
env.io.atom_files_directory = ['.']
env.libs.topology.read(file = 'PARAMS/top_allh.lib')
env.libs.parameters.read(file = 'PARAMS/par.lib')

a = AllHModel(env,
              alnfile='USP7_Ub.ali',
              knowns=('5JTV','Q93009'),
              sequence='seq',
              assess_methods=(assess.DOPEHR))

a.starting_model = 1                # index of the first model
a.ending_model = 150                # index of the last model
a.library_schedule = autosched.normal
a.max_var_iterations = 300
a.md_level = refine.fast
a.repeat_optimization = 1
a.max_molpdf = 1e6
a.make()              
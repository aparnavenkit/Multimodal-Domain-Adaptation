Multimodal Domain Adaptation
============================

This is a weakly supervised framework for domain adaptation in a multi-modal context for multi-label classification. This framework is applied to annotate objects such as animals in a target video with subtitles, in the absence of visual demarcators. We start from classifiers trained on external data (the source, in our setting - ImageNet), and iteratively adapt them to the target dataset using textual cues from the subtitles.



## Preamble

This is the state-of-the-art multimodal domain adaptation framework described in:

> Venkitasubramanian, A. N., Tuytelaars, T., and Moens, M.-F. Wildlife recognition in nature documentaries with weak supervision from subtitles and external data. Pattern Recognition Letters. Elsevier 81 (2016), 63–70.


## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/



## Setup

#### Dataset

The dataset used is the DVD [Great Wildlife Moments](https://en.wikipedia.org/wiki/GreatWildlifeMoments) from the BBC. 

#### Preprocessing of text

* Named Entity Recognition: To detect the names of animals in the subtitles, we used the list of animal names from WordNet. Data/animalnames.m contains the animal names in our dataset, extracted using this method.
* Coreference resolution: We used a combination of coreference resolvers:
	* A 'basic' coreference resolver which simply maps a pronoun to the immediately preceding animal mention
	* The [Stanford deterministic coreference resolver](https://stanfordnlp.github.io/CoreNLP/)
	* [Reconcile coreference resolver](https://www.cs.utah.edu/nlp/reconcile/)

#### Preprocessing of vision

Shot cut detection and key frames extraction were done using [Hellier et al. 2012](http://ieeexplore.ieee.org/abstract/document/6467552/) 
Data/pics.txt contains the id (frame numbers) of the video key frames extracted using this method. 

Features were extracted using the CNN-M-128 architecture of VGG-net. 
Data/CNN_frames_code.txt contains the features extracted.

#### Generating weak labels

We mapped every frame to the five subtitles to the left and right of it. All animal names and coreferences in this range of subtitles were assigned to a frame. Data/posClosest.txt contains the set of names associated with every frame.


## Running the system

Download this repository. Then, on the MATLAB command window:

	cd Multimodal-Domain-Adaptation
	addpath(genpath(pwd))
	run main
		
Questions? Bugs? Email me at aparna.venkit@gmail.com

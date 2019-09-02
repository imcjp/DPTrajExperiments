# DPTrajExperiments
 本项目实现自《差分隐私下满足一致性的轨迹流量发布方法》，作者蔡剑平


该文件夹包含了论文《差分隐私下满足一致性的轨迹流量发布算法》（《trajectory flow releasing algorithm with consistency constraint under differential privacy》）所整理的部分实验源码。

其中main.m为实验的主要源码，直接运行该源码即可看到实验结果。其中包含了数据加载，差分隐私流量图发布算法以及一致性调节算法的调用，并将最后的结果统计输出等。

consistencyAdjustment.m为文献中的一致性调节算法源码（算法2），GenLaplace.m为产生拉普拉斯的函数。

数据文件包含在文件夹'Oldenburg','SanJoaquin','SanFranciscoBayArea'中。这些文件夹分别包含了节点位置，道路信息和部分轨迹数据。由于空间限制，轨迹集只保留了部分，这并不会影响实验结果。如需大量的轨迹数据集，可自行下载轨迹生成器（http://iapg.jade-hs.de/personen/brinkhoff/generator/ 
）生成轨迹。

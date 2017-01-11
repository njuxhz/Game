# Game

## 概述
这是一款跑酷类游戏应用，跑的时间越长，得分越高

## 功能实现
* 框架应用
	* 采用SpriteKit框架制作的场景应用，swift实现
* 主角控制：点击屏幕可以使得主角有向上加速度
	* 不进行操作会使得主角受重力而下落
	* 活动范围为屏幕顶至大地的区间内
* 成绩计算
	* 无限类跑酷游戏，坚持时间为成绩，按秒记
	* 底部记分板实时统计成绩
* 障碍物
	* 随机位置出现、旋转速度随机的棒形障碍，主角碰到旋转的棒形即为失败
	* 随机位置出现、不断翻转的金币，碰到金币即增加成绩，+3s
* 皮肤功能
	* 开场前可跳转至皮肤选择界面，选取喜欢的颜色帽子作为皮肤
* 背景
	* 随场景切换背景音乐
	* 游戏背景随前进运动而向后移动

##  测试截图
* 初始场景
	* ![初始场景](https://github.com/njuxhz/Game/blob/master/MyTest/StartGame.png)
* 初始场景
	* ![初始场景](https://github.com/njuxhz/Game/blob/master/MyTest/ChangeSkin.png)
* 游戏中
	* ![游戏中](https://github.com/njuxhz/Game/blob/master/MyTest/InGame.png)
* 分数统计
	* ![分数统计](https://github.com/njuxhz/Game/blob/master/MyTest/Score.png)
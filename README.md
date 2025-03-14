# SkyWalk
This is a Game Server FrameWork use by Modern C++


## PRINCIPLE:
- COMPLETE IS BETTER THAN PERFECT
- MADE IT BETTER THAN BEFORE


## STEP BY STEP:

### First Stage(Basic): 
	- 1 made it run(delete some unuseful/bad-smell/olde-style code pieces like pthread Unordered_Map and so on)
	- 2 add necessary component(io/framework/log/protobuf/json/xml/redis/mysql)
	- 3 some useful code(base/utils/domain/thirdparty)
	- 4 gate/gs/db/world/master
	- 5 server framework

### Second Stage(Refactor):
	- 1 use modern cpp style modify some code
	- 2 replace log library(or rewrite)
	- 3 lua/protobuf/json/xml 
	- 4 sql/redis interface
	- 5 framework refactor
	- 6 refactor dbserver use by redis+mysql+caches

### Third Stage(Promotion):
	- 1 use your own net library(cross platform, iocp/epoll/kcp/quic and so on)
	- 2 use your owner framework
	- 3 made framework changeable/reuseable/adapterable
	- 4 import coroutine write asynchronisation function call




### 十字链表AOI
	场景维护x，y轴两个双向链表，每个链表按坐标大小排序，对象移动触发AOI事件
+ 优缺点   
短距离移动时，计算量较小，但长距离移动时计算量较大
+ 对象进入   
遍历x，y轴两个链表，将对象插入指定位置，通知对象视野范围内的对象列表AOI进入事件
+ 对象离开   
遍历x，y轴两个链表，将对象从指定位置移除，通知对象视野范围内的对象列表AOI离开事件
+ 对象移动
	1. 如果对象位置无变化，则不做任何操作
	2. 更新位置前的集合，通知视野范围内的对象列表AOI进入事件
	3. 更新位置后的集合，通知视野范围内的对象列表AOI离开事件
	4. 更新位置前的集合，更新位置后的集合的交接，通知AOI移动事件
### 九宫格AOI
	把场景划分为等大的格子，维护相邻9个格子上的对象列表
+ 优缺点  
对象进入离开时间复杂度O(1)，对象移动计算量较大
+ 坐标系
	- 世界坐标系：(x, y) 游戏坐标系  
	- 格子坐标系：(x / 格子大小, y / 格子大小)
+ 对象进入
	1. 世界坐标系转换成格子坐标系，找到对象所属的格子
	2. 通知对象所属格子周围9个格子的其他对象AOI进入事件
+ 对象离开
	1. 世界坐标系转换成格子坐标系，找到对象所属的格子
	2. 通知对象所属格子周围9个格子的其他对象AOI离开事件
+ 对象移动
	1. 世界坐标系转换成格子坐标系，找到对象所属的格子
	2. 如果对象所属的格子没变化，则不做任何操作
	3. 对象离开视野的格子，通知对象AOI进入事件
	4. 对象进入视野的格子，通知对象AOI离开事件
	5. 移动前周围9个格子，移动后周围9个格子的交集，通知对象AOI移动事件
### 灯塔AOI
	把场景划分为等大的格子，每个格子里树立灯塔，对象进入或退出格子时，维护每个灯塔上的对象列表
+ 优缺点  
对象进入离开时间复杂度O(1)，对象移动计算量较大
+ 视野
	- **玩家视野**：屏幕大小
	- **灯塔视野**：1/2，1/3玩家视野最佳
+ 坐标系
	- **世界坐标系**：(x, y) 游戏坐标
	- **灯塔坐标系**：(x / (2 * **灯塔视野** + 1), y /(2 * **灯塔视野** + 1))
+ 对象进入
	1. 世界坐标系转换成灯塔坐标系，找到所属的灯塔
	2. 将对象添加到灯塔的对象列表，通知灯塔上的观察者对象列表AOI进入事件
	3. 找出视野范围内的灯塔，将自身绑定为观察者，通知自身视野范围内的灯塔中的对象列表AOI进入事件   
+ 对象离开
	1. 世界坐标系转换成灯塔坐标系，找到所属的灯塔
	2. 将对象从灯塔对象列表中移除，通知灯塔上的观察者对象列表AOI离开事件
	3. 找出视野范围内的灯塔，解除自身观察者绑定，通知自身视野范围内的灯塔中的对象列表AOI离开事件
+ 对象移动
	1. 世界坐标系转换成灯塔坐标系，找到所属的灯塔
	2. 如果对象所属的灯塔没变，则不做任何操作
	3. 如果对象所属的灯塔改变，则对旧的灯塔执行**对象离开**逻辑，对新的灯塔执行**对象进入**逻辑

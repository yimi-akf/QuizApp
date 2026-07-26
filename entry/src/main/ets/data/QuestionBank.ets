import { Question, QuestionType, Difficulty, Topic } from '../model/Question';
import { shuffleArray } from '../utils/ArrayUtil';

// 题库数据
// 来源：趣味综合题库大全（升级版）.docx
// 共 500 题
const allQuestions: Question[] = [
  {
    id: 1,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '太阳系最大的行星是哪颗？',
    options: [],
    correctIndex: -1,
    explanation: '答案：木星'
  },
  {
    id: 2,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '水的化学式是什么？',
    options: ['CO2', 'H2O', 'O2', 'NaCl'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 3,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '彩虹有几种颜色？',
    options: [],
    correctIndex: -1,
    explanation: '答案：7种'
  },
  {
    id: 4,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个是可再生能源？',
    options: ['煤炭', '石油', '太阳能', '天然气'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 5,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '世界上最高的山峰叫什么名字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：珠穆朗玛峰'
  },
  {
    id: 6,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '地球的自转产生了四季变化。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 7,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '中国古代四大发明不包括？',
    options: ['造纸术', '火药', '地动仪', '印刷术'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 8,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种动物不是哺乳动物？',
    options: ['鲸鱼', '海豚', '鲨鱼', '蝙蝠'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 9,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的骨头是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：股骨（大腿骨）'
  },
  {
    id: 10,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的器官是什么？',
    options: ['心脏', '肝脏', '皮肤', '大脑'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 11,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '彩虹的七种颜色从上到下的顺序是？',
    options: ['红橙黄绿青蓝紫', '紫蓝青绿黄橙红', '红绿黄蓝橙青紫', '橙黄绿青蓝紫红'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 12,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种颜色不是颜料三原色？',
    options: ['红', '黄', '绿', '蓝'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 13,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '地球是太阳系第几颗行星？',
    options: ['第二颗', '第三颗', '第四颗', '第五颗'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 14,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '一年有多少个节气？',
    options: [],
    correctIndex: -1,
    explanation: '答案：24个'
  },
  {
    id: 15,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '太阳系中离太阳最近的行星是？',
    options: ['金星', '水星', '地球', '火星'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 16,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '月亮本身会发光。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 17,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '鲸鱼属于鱼类。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 18,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '蜗牛是世界上牙齿最多的动物。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 19,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '澳大利亚的首都是哪里？',
    options: [],
    correctIndex: -1,
    explanation: '答案：堪培拉'
  },
  {
    id: 20,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '企鹅生活在北极。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 21,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '竹子是树。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 22,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.KNOWLEDGE,
    title: '地球上最硬的天然矿物是什么？',
    options: ['黄金', '钻石', '铁', '玻璃'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 23,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '地球绕太阳公转一圈是一年，那如果从北极上空俯看，地球是逆时针转；但如果你站在南极上空看，地球公转方向会是什么样？',
    options: ['还是逆时针', '变成顺时针', '静止不动', '一会儿顺一会儿逆'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 24,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '中国四大名著中，哪部是曹雪芹写的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：《红楼梦》'
  },
  {
    id: 25,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '长城是从秦朝开始修建的。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 26,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '以下哪位是\'唐宋八大家\'之一？',
    options: ['李白', '杜甫', '苏轼', '陆游'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 27,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种动物的心脏结构与人类最相似？',
    options: ['鱼', '青蛙', '鸽子', '猪'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 28,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的半岛是？',
    options: ['印度半岛', '中南半岛', '阿拉伯半岛', '斯堪的纳维亚半岛'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 29,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '第一次工业革命的标志是？',
    options: ['电力的广泛应用', '蒸汽机的改良', '计算机的发明', '蒸汽机的发明'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 30,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '人体血液循环的动力器官是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：心脏'
  },
  {
    id: 31,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '地球的赤道周长约为4万公里。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 32,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '中国历史上第一个统一的封建王朝是哪个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：秦朝'
  },
  {
    id: 33,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '鲸鱼是用肺呼吸的。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 34,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '中国古代四大美女之一，有\'沉鱼\'之称的是谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：西施'
  },
  {
    id: 35,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: 'DNA双螺旋结构的发现者是？',
    options: ['孟德尔', '沃森和克里克', '达尔文', '摩尔根'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 36,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上面积最大的热带雨林位于？',
    options: ['刚果盆地', '亚马逊平原', '东南亚', '马达加斯加'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 37,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '《清明上河图》描绘的是哪个城市的景象？',
    options: ['长安', '洛阳', '汴京', '临安'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 38,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '长城的总长度（包括历代修建的所有城墙、壕堑、山险等）大约有多长？',
    options: ['6000公里', '1万公里', '2万公里', '超过2.1万公里'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 39,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最长的河流是？',
    options: ['亚马逊河', '尼罗河', '长江', '密西西比河'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 40,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最长的人工运河叫什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：京杭大运河'
  },
  {
    id: 41,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '蝙蝠是唯一会真正飞行的哺乳动物。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 42,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '光速在任何介质中都是一样的。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 43,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个不是中国古代\'三教九流\'中的三教？',
    options: ['儒教', '道教', '佛教', '基督教'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 44,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '青霉素是谁发现的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：弗莱明'
  },
  {
    id: 45,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种气体是温室气体的主要成分？',
    options: ['氧气', '氮气', '二氧化碳', '氢气'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 46,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '人体有206块骨头。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 47,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '中国古代\'四书五经\'中的四书不包括？',
    options: ['《大学》', '《中庸》', '《论语》', '《道德经》'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 48,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '俄罗斯是世界上面积最大的国家，它的国土面积比以下哪个大洲（或大陆）小？',
    options: ['欧洲', '南极洲', '南美洲', '大洋洲'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 49,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最深的海沟是？',
    options: ['波多黎各海沟', '马里亚纳海沟', '日本海沟', '千岛海沟'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 50,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种物质的导热性最好？',
    options: ['铁', '铜', '铝', '银'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 51,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最小的国家叫什么名字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：梵蒂冈'
  },
  {
    id: 52,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '声音在以下哪种介质中传播速度最快？',
    options: ['空气', '水', '钢铁', '真空'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 53,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最咸的海是死海。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 54,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的沙漠叫什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：撒哈拉沙漠'
  },
  {
    id: 55,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的解毒器官是？',
    options: ['肾脏', '肝脏', '脾脏', '肺'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 56,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '企鹅是鸟类但不会飞。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 57,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的内分泌腺是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：甲状腺'
  },
  {
    id: 58,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '光合作用的主要场所是？',
    options: ['线粒体', '叶绿体', '细胞核', '核糖体'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 59,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '太阳的能量来源于什么反应？',
    options: [],
    correctIndex: -1,
    explanation: '答案：核聚变反应'
  },
  {
    id: 60,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '所有的金属在常温下都是固体。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 61,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '《西游记》的作者是罗贯中。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 62,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种血型被称为\'万能供血者\'？',
    options: ['A型', 'B型', 'AB型', 'O型'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 63,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '我们都知道皮肤是人体最大的器官，那么人体最大的内脏器官是哪一个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：肝脏'
  },
  {
    id: 64,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个不是暗物质存在的证据？',
    options: ['星系旋转曲线', '引力透镜效应', '宇宙微波背景辐射', '黑洞的存在'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 65,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '中国古代医圣是指谁？',
    options: ['华佗', '张仲景', '李时珍', '扁鹊'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 66,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪位科学家被称为\'近代科学之父\'？',
    options: ['牛顿', '伽利略', '爱因斯坦', '哥白尼'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 67,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人类第一次登月是在哪一年？',
    options: ['1961年', '1965年', '1969年', '1972年'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 68,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最坚硬的组织是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：牙釉质'
  },
  {
    id: 69,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '月球上的环形山主要是火山喷发形成的。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 70,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的咸水湖是？',
    options: ['贝加尔湖', '里海', '死海', '咸海'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 71,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最深的洞穴是库鲁伯亚拉洞穴。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 72,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的内分泌腺是什么？',
    options: ['垂体', '甲状腺', '肾上腺', '胰腺'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 73,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '在南半球，冲马桶时水的漩涡方向一定与北半球相反（即北半球逆时针，南半球顺时针）。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 74,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: 'X射线是谁发现的？',
    options: ['居里夫人', '伦琴', '贝克勒尔', '卢瑟福'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 75,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '中国古代四大发明中，哪项发明最早？',
    options: ['造纸术', '指南针', '火药', '印刷术'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 76,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '中国古代书圣是指谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：王羲之'
  },
  {
    id: 77,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '太平洋的面积比月球表面的总面积还要大。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 78,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '普朗克常量是哪个物理领域的基本常数？',
    options: [],
    correctIndex: -1,
    explanation: '答案：量子力学'
  },
  {
    id: 79,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上流量最大的河流是？',
    options: ['尼罗河', '亚马逊河', '长江', '密西西比河'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 80,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上第一个因为动力飞机空难而遇难的人是谁？（非滑翔机，指有发动机的飞机）',
    options: ['奥维尔·莱特', '威尔伯·莱特', '托马斯·塞弗里奇（Thomas Selfridge）', '奥托·李林塔尔'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 81,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '光在真空中的传播速度约为多少？',
    options: ['30万公里/秒', '3万公里/秒', '300万公里/秒', '3000公里/秒'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 82,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最长的骨头是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：股骨（大腿骨）'
  },
  {
    id: 83,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的消化腺是？',
    options: ['胃', '肝脏', '胰腺', '胆囊'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 84,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '宇宙大爆炸大约发生在多少年前？',
    options: [],
    correctIndex: -1,
    explanation: '答案：约138亿年前'
  },
  {
    id: 85,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '地球大气中含量最多的气体是氧气。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 86,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的花是什么？',
    options: ['向日葵', '大王花', '荷花', '牡丹'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 87,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最深的湖泊是？',
    options: ['里海', '贝加尔湖', '苏必利尔湖', '维多利亚湖'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 88,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最长的山脉是？',
    options: ['喜马拉雅山脉', '安第斯山脉', '落基山脉', '阿尔卑斯山脉'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 89,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '光的三原色是哪三种？',
    options: [],
    correctIndex: -1,
    explanation: '答案：红、绿、蓝'
  },
  {
    id: 90,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上第一台电子计算机叫什么？',
    options: ['UNIVAC', 'ENIAC', 'EDVAC', 'Mark I'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 91,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人眼能分辨大约1000万种颜色。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 92,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的群岛国家是哪个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：印度尼西亚'
  },
  {
    id: 93,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '爱因斯坦的质能方程是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：E=mc²'
  },
  {
    id: 94,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '非洲的总面积比俄罗斯、中国、美国三个国家的面积加起来还要大。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 95,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '爱因斯坦因为提出狭义相对论而获得了诺贝尔物理学奖。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 96,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '1903年莱特兄弟首次成功飞行，那一次飞机在空中共持续了 多少秒？',
    options: ['3秒', '12秒', '59秒', '1分32秒'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 97,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个是\'薛定谔的猫\'实验想要说明的？',
    options: ['猫有九条命', '量子叠加态的悖论', '猫的生命力顽强', '放射性衰变的规律'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 98,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '镭元素是谁发现的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：居里夫人'
  },
  {
    id: 99,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '电话是谁发明的？',
    options: ['爱迪生', '贝尔', '特斯拉', '马可尼'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 100,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的淋巴器官是脾脏。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 101,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个不是太阳系的行星？',
    options: ['天王星', '冥王星', '海王星', '水星'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 102,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《天工开物》的作者是谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：宋应星'
  },
  {
    id: 103,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体血液的pH值大约是多少？',
    options: ['6.5左右', '7.4左右', '8.0左右', '7.0左右'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 104,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '澳大利亚是世界上最小的大陆，格陵兰岛是世界上最大的岛屿。为什么澳大利亚是“大陆”而面积相近的格陵兰岛却是“岛”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为澳大利亚坐落在自己的大陆架上，而格陵兰是北美大陆架的一部分'
  },
  {
    id: 105,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '中国古代诗圣是指谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：杜甫'
  },
  {
    id: 106,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '纽科门蒸汽机比瓦特改良后的蒸汽机，最致命的缺陷是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：在气缸内直接喷水冷凝，导致大量热量被浪费。'
  },
  {
    id: 107,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的平原是哪个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：亚马逊平原'
  },
  {
    id: 108,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '黑洞的边界被称为？',
    options: ['奇点', '事件视界', '吸积盘', '光锥'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 109,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上面积第二大的岛屿是？',
    options: ['新几内亚岛', '格陵兰岛', '加里曼丹岛', '马达加斯加岛'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 110,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个行星的卫星数量最多？',
    options: ['木星', '土星', '天王星', '海王星'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 111,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种气体有臭鸡蛋气味？',
    options: ['二氧化碳', '硫化氢', '氨气', '氯气'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 112,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《几何原本》的作者是欧几里得。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 113,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '暗能量占宇宙总质能的比例约为？',
    options: ['约5%', '约27%', '约68%', '约95%'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 114,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最大的肌肉是什么？',
    options: ['肱二头肌', '臀大肌', '股四头肌', '腹肌'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 115,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪一位是没有被证实是真实存在过的历史人物？',
    options: ['孔子', '老子', '庄子', '孟子'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 116,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '我们平常梳头、剪发时触碰到的头发（发干部分），是活的还是死的？',
    options: ['活的，因为头发会不断长长', '死的，因为发干由角蛋白组成，没有血管和神经', '半死不活的，介于两者之间', '看情况，刚洗过头就是活的，干了就是死的'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 117,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '除了水银之外，常温下还有至少两种金属是液态的。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 118,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的哺乳动物是非洲象。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 119,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '铅笔芯中的石墨和钻石是由同一种化学元素组成的。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 120,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '中国古代丝绸之路的起点是？',
    options: ['洛阳', '长安', '敦煌', '北京'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 121,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《论语》中“子曰”的“子”字，在全书所有篇章中都指代同一个人——孔子。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 122,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最长的跨海大桥是哪座？',
    options: [],
    correctIndex: -1,
    explanation: '答案：港珠澳大桥'
  },
  {
    id: 123,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《本草纲目》的作者是？',
    options: ['华佗', '李时珍', '张仲景', '扁鹊'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 124,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '运动速度越快，时间流逝越慢。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 125,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '地球的核心主要由什么金属组成？',
    options: ['铜和锌', '铁和镍', '铝和镁', '金和银'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 126,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最高的瀑布叫什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：安赫尔瀑布'
  },
  {
    id: 127,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最长的山脉是什么山脉？',
    options: [],
    correctIndex: -1,
    explanation: '答案：安第斯山脉'
  },
  {
    id: 128,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '所有的植物都能进行光合作用。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 129,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '万有引力常量G是谁精确测量的？',
    options: ['牛顿', '卡文迪许', '伽利略', '开普勒'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 130,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《史记》中的“本纪”本来是记载帝王的，但以下哪位不是皇帝，却被司马迁写进了“本纪”？',
    options: ['项羽', '刘邦', '嬴政', '刘秀'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 131,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的淡水湖是？',
    options: ['贝加尔湖', '苏必利尔湖', '里海', '密歇根湖'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 132,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪个不是四大文明古国？',
    options: ['古埃及', '古希腊', '古巴比伦', '古印度'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 133,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体成人有28-32颗牙齿。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 134,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最古老的文字是甲骨文。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 135,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '暗物质占宇宙总质能的比例约为27%。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 136,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '由于地球自转速度在逐渐变慢，所以现在的一天比恐龙时代的一天要更长。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 137,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人类大约有 2-3 万个基因，但以下哪种生物的基因数量比人类还多？',
    options: ['果蝇', '水稻', '老鼠', '以上都是'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 138,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《史记》中有一部分篇章并非司马迁本人所写，而是由后人补写的。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 139,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '太阳系中自转最快的行星是？',
    options: ['地球', '木星', '土星', '海王星'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 140,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《三国演义》的开篇词“滚滚长江东逝水”是谁所写？',
    options: [],
    correctIndex: -1,
    explanation: '答案：杨慎'
  },
  {
    id: 141,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体中含量最多的金属元素是什么？',
    options: ['铁', '钙', '钠', '钾'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 142,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《资治通鉴》的书名含义中，“资治”二字的准确理解是什么？',
    options: ['资助政治', '资治通鉴的简称', '提供治理国家的借鉴', '研究政治的工具书'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 143,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '太阳系中唯一逆向自转的行星是？',
    options: ['水星', '金星', '火星', '天王星'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 144,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '太阳系中目前已知最冷的自然天体是哪个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：冥王星'
  },
  {
    id: 145,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最小的骨头位于哪里？',
    options: ['手指', '耳朵', '脚趾', '鼻子'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 146,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上第一个人工合成的蛋白质是什么？',
    options: ['胰岛素', '牛胰岛素', '血红蛋白', '抗体'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 147,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '太阳系中最小的行星是哪颗？',
    options: [],
    correctIndex: -1,
    explanation: '答案：水星'
  },
  {
    id: 148,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '量子力学中的\'测不准原理\'是由谁提出的？',
    options: ['爱因斯坦', '玻尔', '海森堡', '薛定谔'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 149,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《孙子兵法》的作者是孙膑。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 150,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '门捷列夫发明元素周期表后，他是否获得了诺贝尔奖？',
    options: ['获得过诺贝尔化学奖', '从未获得诺贝尔奖', '获得过诺贝尔物理学奖', '1906年获得提名但未获奖'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 151,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '无线电是马可尼发明的。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 152,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '根据地理学定义，世界上最大的沙漠是哪个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：南极洲'
  },
  {
    id: 153,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最干燥的地方是？',
    options: ['撒哈拉沙漠', '阿塔卡马沙漠', '塔克拉玛干沙漠', '戈壁沙漠'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 154,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '北冰洋虽然是四大洋中面积最小的，但它的面积大约相当于哪个大洲的面积？',
    options: ['欧洲', '大洋洲', '南美洲', '非洲'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 155,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最古老的大学是意大利的博洛尼亚大学。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 156,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '以下哪种动物的寿命最长？',
    options: ['大象', '格陵兰鲨', '乌龟', '鲸鱼'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 157,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '臭氧层能吸收紫外线保护地球生物。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 158,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '人体最小的内分泌腺是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：松果体'
  },
  {
    id: 159,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最长的河流峡谷是雅鲁藏布大峡谷。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 160,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '地球上离地心最远的点在哪里？',
    options: [],
    correctIndex: -1,
    explanation: '答案：厄瓜多尔的钦博拉索山'
  },
  {
    id: 161,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '我国历史上第一部词典叫什么名字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：《尔雅》'
  },
  {
    id: 162,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '电报是谁发明的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：莫尔斯'
  },
  {
    id: 163,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '中国古代四大发明这个说法最早是由谁提出的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：英国汉学家艾约瑟'
  },
  {
    id: 164,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最大的内陆国是哪个？',
    options: [],
    correctIndex: -1,
    explanation: '答案：哈萨克斯坦'
  },
  {
    id: 165,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '《梦溪笔谈》的作者是谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：沈括'
  },
  {
    id: 166,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最年轻的国家是？',
    options: ['东帝汶', '南苏丹', '科索沃', '厄立特里亚'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 167,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.KNOWLEDGE,
    title: '世界上最古老的文字是？',
    options: ['甲骨文', '楔形文字', '象形文字', '腓尼基字母'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 168,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么动物最容易被贴在墙上？',
    options: ['壁虎', '海豹', '蜘蛛', '蜗牛'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 169,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '用铁锤锤鸡蛋，为什么锤不破？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为锤子不会破'
  },
  {
    id: 170,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '谜语：“一口咬掉牛尾巴” —— 打一个字。',
    options: [],
    correctIndex: -1,
    explanation: '答案：告'
  },
  {
    id: 171,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么东西越洗越脏？',
    options: ['衣服', '水', '手', '碗'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 172,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么东西天气越热它爬得越高？',
    options: [],
    correctIndex: -1,
    explanation: '答案：温度计'
  },
  {
    id: 173,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '谜语：一人一张口，口下长只手 —— 打一个字',
    options: [],
    correctIndex: -1,
    explanation: '答案：拿'
  },
  {
    id: 174,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '小明的妈妈有三个儿子，大儿子叫大毛，二儿子叫二毛，三儿子叫什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：小明'
  },
  {
    id: 175,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '谜语：七十二小时 —— 打一个字',
    options: ['时', '晶', '春', '明'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 176,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '谜语：一百减一 —— 打一个字',
    options: [],
    correctIndex: -1,
    explanation: '答案：白'
  },
  {
    id: 177,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么路最窄？',
    options: [],
    correctIndex: -1,
    explanation: '答案：冤家路窄'
  },
  {
    id: 178,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么东西有嘴不会说话？',
    options: [],
    correctIndex: -1,
    explanation: '答案：茶壶'
  },
  {
    id: 179,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么书在书店里买不到？答案是遗书？',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 180,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么东西有嘴不说话，有脚不走路？',
    options: [],
    correctIndex: -1,
    explanation: '答案：桌子'
  },
  {
    id: 181,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '一年四季都盛开的花是什么花？',
    options: [],
    correctIndex: -1,
    explanation: '答案：假花'
  },
  {
    id: 182,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么东西没吃的时候是绿的，吃的时候是红的，吐出来是黑的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：西瓜'
  },
  {
    id: 183,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么车寸步难行？',
    options: [],
    correctIndex: -1,
    explanation: '答案：风车'
  },
  {
    id: 184,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么牛不会吃草？',
    options: [],
    correctIndex: -1,
    explanation: '答案：蜗牛'
  },
  {
    id: 185,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '晚上才生出尾巴的是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：流星'
  },
  {
    id: 186,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么鱼不能吃？',
    options: ['鲤鱼', '木鱼', '草鱼', '鲫鱼'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 187,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么马不能骑？',
    options: ['白马', '海马', '黑马', '骏马'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 188,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '什么动物你打死了它，却流了你的血？',
    options: [],
    correctIndex: -1,
    explanation: '答案：蚊子'
  },
  {
    id: 189,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.RIDDLE,
    title: '早晨醒来每个人做的第一件事是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：睁开眼睛【进阶难度】'
  },
  {
    id: 190,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越喝越渴？',
    options: [],
    correctIndex: -1,
    explanation: '答案：海水'
  },
  {
    id: 191,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西买的人知道，卖的人也知道，只有用的人不知道？',
    options: [],
    correctIndex: -1,
    explanation: '答案：棺材'
  },
  {
    id: 192,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西有五个头但人不觉得它怪？',
    options: [],
    correctIndex: -1,
    explanation: '答案：手和脚'
  },
  {
    id: 193,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么情况下 0 大于 2，2 大于 5，5 大于 0？',
    options: [],
    correctIndex: -1,
    explanation: '答案：猜拳的时候'
  },
  {
    id: 194,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越热越凝固？',
    options: [],
    correctIndex: -1,
    explanation: '答案：蛋'
  },
  {
    id: 195,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西打碎了自然会和好？',
    options: [],
    correctIndex: -1,
    explanation: '答案：水面'
  },
  {
    id: 196,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '有一样东西，你只能用左手拿它，右手永远拿不到？',
    options: [],
    correctIndex: -1,
    explanation: '答案：自己的右手'
  },
  {
    id: 197,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么交通工具速度越慢越让人恐惧？',
    options: [],
    correctIndex: -1,
    explanation: '答案：正在飞行的飞机'
  },
  {
    id: 198,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '狼来了，打一水果？',
    options: [],
    correctIndex: -1,
    explanation: '答案：杨桃'
  },
  {
    id: 199,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '太平洋的中间是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：平'
  },
  {
    id: 200,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西可以穿过玻璃却不会打碎玻璃？',
    options: [],
    correctIndex: -1,
    explanation: '答案：光'
  },
  {
    id: 201,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么数字最听话？',
    options: [],
    correctIndex: -1,
    explanation: '答案：100，百依百顺'
  },
  {
    id: 202,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越分享越多？',
    options: [],
    correctIndex: -1,
    explanation: '答案：快乐'
  },
  {
    id: 203,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '两对父子去买帽子，只买了三顶，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：祖孙三代人'
  },
  {
    id: 204,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越晒越湿？',
    options: [],
    correctIndex: -1,
    explanation: '答案：冰块'
  },
  {
    id: 205,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么桥没有水？',
    options: [],
    correctIndex: -1,
    explanation: '答案：立交桥'
  },
  {
    id: 206,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西晚上才生出尾巴？',
    options: ['月亮', '流星', '彗星', '星星'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 207,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '一只鸡，一只鹅，放冰箱里，鸡冻死了鹅没事，为啥？',
    options: [],
    correctIndex: -1,
    explanation: '答案：是企鹅'
  },
  {
    id: 208,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '老王一天要刮四五十次脸，脸上仍有胡子，为何？',
    options: [],
    correctIndex: -1,
    explanation: '答案：他在给别人刮胡子'
  },
  {
    id: 209,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越冷越出来？',
    options: [],
    correctIndex: -1,
    explanation: '答案：鼻涕'
  },
  {
    id: 210,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越晒越干？',
    options: [],
    correctIndex: -1,
    explanation: '答案：湿衣服'
  },
  {
    id: 211,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西有眼看不见？',
    options: [],
    correctIndex: -1,
    explanation: '答案：针'
  },
  {
    id: 212,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '人为什么要走去床上睡觉？',
    options: [],
    correctIndex: -1,
    explanation: '答案：床不会自己走过来'
  },
  {
    id: 213,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么鱼最聪明？',
    options: [],
    correctIndex: -1,
    explanation: '答案：鲸（精）鱼'
  },
  {
    id: 214,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西左手能拿到右手拿不到？',
    options: [],
    correctIndex: -1,
    explanation: '答案：右手'
  },
  {
    id: 215,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么书没有字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：天书'
  },
  {
    id: 216,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西可以填满整个房间却不占空间？',
    options: [],
    correctIndex: -1,
    explanation: '答案：光'
  },
  {
    id: 217,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么情况下一山能容二虎？',
    options: [],
    correctIndex: -1,
    explanation: '答案：一公一母'
  },
  {
    id: 218,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '羊来了，打一水果？',
    options: [],
    correctIndex: -1,
    explanation: '答案：草莓'
  },
  {
    id: 219,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '小白加小白等于什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：小白兔（two）'
  },
  {
    id: 220,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越旧越值钱？',
    options: [],
    correctIndex: -1,
    explanation: '答案：古董'
  },
  {
    id: 221,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '用什么可以解开所有的谜？',
    options: [],
    correctIndex: -1,
    explanation: '答案：答案'
  },
  {
    id: 222,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么风最没力气？',
    options: [],
    correctIndex: -1,
    explanation: '答案：耳旁风'
  },
  {
    id: 223,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越生气越大？',
    options: [],
    correctIndex: -1,
    explanation: '答案：脾气'
  },
  {
    id: 224,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么球离你最近？',
    options: [],
    correctIndex: -1,
    explanation: '答案：眼球'
  },
  {
    id: 225,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '大象的左耳朵像什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：右耳朵'
  },
  {
    id: 226,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么动物最爱贴在墙上？',
    options: [],
    correctIndex: -1,
    explanation: '答案：海豹（报）'
  },
  {
    id: 227,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西没有脚却能走遍天下？',
    options: [],
    correctIndex: -1,
    explanation: '答案：风'
  },
  {
    id: 228,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越大越没用？',
    options: [],
    correctIndex: -1,
    explanation: '答案：破洞'
  },
  {
    id: 229,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么书里毛病最多？',
    options: [],
    correctIndex: -1,
    explanation: '答案：医学书'
  },
  {
    id: 230,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '为什么大雁秋天要往南飞？',
    options: [],
    correctIndex: -1,
    explanation: '答案：走过去太慢'
  },
  {
    id: 231,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '世界上什么人一下子变老？',
    options: [],
    correctIndex: -1,
    explanation: '答案：新娘，一夜变老婆'
  },
  {
    id: 232,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西上升的时候同时会下降？',
    options: ['电梯', '跷跷板', '太阳', '潮水'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 233,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么动物没有方向感？',
    options: [],
    correctIndex: -1,
    explanation: '答案：麋鹿（迷路）'
  },
  {
    id: 234,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '最长的路是什么路？',
    options: [],
    correctIndex: -1,
    explanation: '答案：套路'
  },
  {
    id: 235,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么动物最爱熬夜？',
    options: [],
    correctIndex: -1,
    explanation: '答案：熊猫，有黑眼圈'
  },
  {
    id: 236,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '从不挑食的人是谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：盲人'
  },
  {
    id: 237,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西人们都不喜欢吃？',
    options: [],
    correctIndex: -1,
    explanation: '答案：吃亏'
  },
  {
    id: 238,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么表没有指针？',
    options: [],
    correctIndex: -1,
    explanation: '答案：体温表'
  },
  {
    id: 239,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么动物坐也是坐，站也是坐？',
    options: [],
    correctIndex: -1,
    explanation: '答案：青蛙'
  },
  {
    id: 240,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越用越亮？',
    options: [],
    correctIndex: -1,
    explanation: '答案：脑子'
  },
  {
    id: 241,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么山没有石头？什么海没有水？',
    options: [],
    correctIndex: -1,
    explanation: '答案：人山人海'
  },
  {
    id: 242,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '小白猫掉进水里，小黑猫救了它，小白猫第一句说什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：喵'
  },
  {
    id: 243,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么东西越热越爱出来？',
    options: [],
    correctIndex: -1,
    explanation: '答案：汗水'
  },
  {
    id: 244,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么饭不能在晚上吃？',
    options: [],
    correctIndex: -1,
    explanation: '答案：早饭、午饭'
  },
  {
    id: 245,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '什么季节最短？',
    options: [],
    correctIndex: -1,
    explanation: '答案：秋季（一日三秋）'
  },
  {
    id: 246,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.RIDDLE,
    title: '用椰子和西瓜打头哪个更疼？',
    options: [],
    correctIndex: -1,
    explanation: '答案：头最疼【挑战难度】'
  },
  {
    id: 247,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越想越想不通？',
    options: [],
    correctIndex: -1,
    explanation: '答案：脑筋急转弯'
  },
  {
    id: 248,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越交流越理解？',
    options: [],
    correctIndex: -1,
    explanation: '答案：沟通'
  },
  {
    id: 249,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西你追赶它，它却离你越来越远？',
    options: [],
    correctIndex: -1,
    explanation: '答案：明天（未来）'
  },
  {
    id: 250,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西明明是你的，别人却比你用得多？',
    options: [],
    correctIndex: -1,
    explanation: '答案：你的名字'
  },
  {
    id: 251,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么鹿和鸡是亲戚？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为"录像机"（鹿像鸡）'
  },
  {
    id: 252,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '爷爷熟读兵书，却食古不化，每次跟孙子们玩棋都输，请问爷爷用的什么战术？',
    options: [],
    correctIndex: -1,
    explanation: '答案：兵来将挡'
  },
  {
    id: 253,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '盆里有六只馒头，一个小朋友每人分到一只，但盆里还留着一只，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：最后一个小朋友把盆子一起拿走了'
  },
  {
    id: 254,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西可以向上爬也可以向下走，但自己却不会动？',
    options: ['电梯', '楼梯', '山', '树'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 255,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '小王是一名优秀士兵，一天他在站岗值勤时，明明看到有敌人悄悄向他摸过来，为什么他却睁一只眼闭一只眼？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为他正在瞄准'
  },
  {
    id: 256,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人掉进游泳池里，他的脚却没有湿，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：游泳池里没有水'
  },
  {
    id: 257,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '船边挂着软梯，离海面2米，海水每小时上涨半米，几个小时海水能淹没软梯？',
    options: [],
    correctIndex: -1,
    explanation: '答案：永远淹不到，水涨船高'
  },
  {
    id: 258,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '电车时速80公里向北行驶，有时速20公里的东风，请问电车的烟朝哪个方向吹？',
    options: [],
    correctIndex: -1,
    explanation: '答案：电车没有烟'
  },
  {
    id: 259,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西有城市却没有房子，有山却没有石头，有水却没有鱼？',
    options: [],
    correctIndex: -1,
    explanation: '答案：地图'
  },
  {
    id: 260,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人从飞机上掉下来，却没有摔死，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：飞机停在地上'
  },
  {
    id: 261,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人被关在密闭的房间里，只有一扇门，但他却怎么也拉不开，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为那扇门是推的'
  },
  {
    id: 262,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么人生病从来不看医生？',
    options: [],
    correctIndex: -1,
    explanation: '答案：盲人'
  },
  {
    id: 263,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越黑越看得清？',
    options: [],
    correctIndex: -1,
    explanation: '答案：星星'
  },
  {
    id: 264,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么蚕宝宝很有钱？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为它会结茧（节俭）'
  },
  {
    id: 265,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越多越不够？',
    options: ['知识', '欲望', '钱', '时间'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 266,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么青蛙可以跳得比树高？',
    options: [],
    correctIndex: -1,
    explanation: '答案：树不会跳'
  },
  {
    id: 267,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么小明能一只手让车子停下来？',
    options: [],
    correctIndex: -1,
    explanation: '答案：他在打车（招手拦出租车）'
  },
  {
    id: 268,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么一只青蛙在水里游不过一只狗？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为禁止蛙泳'
  },
  {
    id: 269,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么老王家的马能吃掉老张家的象？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为他们在下象棋'
  },
  {
    id: 270,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么一只猫看见一只老鼠拔腿就跑？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为猫去追老鼠'
  },
  {
    id: 271,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么一只狗总也不洗澡，却不会生跳蚤',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为狗只能生狗，生不出跳蚤'
  },
  {
    id: 272,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '三个金叫"鑫"，三个水叫"淼"，三个人叫"众"，那么三个鬼叫什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：叫救命'
  },
  {
    id: 273,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人花8块钱买了一只鸡，9块钱卖掉，又用10块钱买回来，11块钱卖掉，请问他赚了多少钱？',
    options: [],
    correctIndex: -1,
    explanation: '答案：赚了2块钱'
  },
  {
    id: 274,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '有10盏灯，关掉3盏，还有几盏灯？',
    options: [],
    correctIndex: -1,
    explanation: '答案：还有10盏灯'
  },
  {
    id: 275,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一只猫吃一只老鼠要5分钟，五只猫同时吃五只老鼠要几分钟？',
    options: [],
    correctIndex: -1,
    explanation: '答案：5分钟'
  },
  {
    id: 276,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越平凡越难得？',
    options: ['奇迹', '真心', '宝物', '奢侈品'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 277,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '1*1在什么情况下不等于1？',
    options: [],
    correctIndex: -1,
    explanation: '答案：算错的情况下'
  },
  {
    id: 278,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西有皮不能吃，有弦不能弹？',
    options: [],
    correctIndex: -1,
    explanation: '答案：二胡'
  },
  {
    id: 279,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么企鹅的肚子是白的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为手短，只能洗到肚子'
  },
  {
    id: 280,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么职业的人最爱说"再来一次"？',
    options: [],
    correctIndex: -1,
    explanation: '答案：导演'
  },
  {
    id: 281,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西干净的时候是黑的，弄脏的时候反而变白？',
    options: [],
    correctIndex: -1,
    explanation: '答案：黑板'
  },
  {
    id: 282,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西可以在火中燃烧却不会被烧坏？',
    options: [],
    correctIndex: -1,
    explanation: '答案：火焰'
  },
  {
    id: 283,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越擦越脏？',
    options: [],
    correctIndex: -1,
    explanation: '答案：抹布'
  },
  {
    id: 284,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '小明住在10楼，每天出门坐电梯到1楼，回来时却只坐到7楼再走楼梯，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：他太矮，够不到10楼的按钮。'
  },
  {
    id: 285,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '第三只狼经过，羊冲狼大叫，狼还是没吃羊，打一动物。',
    options: [],
    correctIndex: -1,
    explanation: '答案：龙虾'
  },
  {
    id: 286,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '两个人掉进陷阱，死掉的那个叫死人，活着的那个叫什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：救命'
  },
  {
    id: 287,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '小明已经提前知道答案，考试时为什么还一直看别人的卷子？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为他是监考老师。'
  },
  {
    id: 288,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人走在独木桥上，前面来了一只狼，后面来了一只虎，他是怎么过去的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：晕过去的。'
  },
  {
    id: 289,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越热闹越冷清？',
    options: [],
    correctIndex: -1,
    explanation: '答案：曲终人散'
  },
  {
    id: 290,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西一旦说出来，就立刻被打破？',
    options: [],
    correctIndex: -1,
    explanation: '答案：沉默'
  },
  {
    id: 291,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西比乌鸦更让人讨厌？',
    options: [],
    correctIndex: -1,
    explanation: '答案：乌鸦嘴'
  },
  {
    id: 292,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么大多数佛教徒都住在北半球？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为南“无”阿弥陀佛'
  },
  {
    id: 293,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '自由女神像为什么一直站在纽约港？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为她不能坐'
  },
  {
    id: 294,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么时候必须“先穿鞋，后穿袜子”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：踩到钉子的时候（钉子先穿透鞋底，再穿过袜子）。'
  },
  {
    id: 295,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '数字1到9，哪个最懒，哪个最勤快？',
    options: [],
    correctIndex: -1,
    explanation: '答案：1最懒，2最勤快——因为“一不做，二不休”。'
  },
  {
    id: 296,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一群狼加另一群狼，等于几群狼？',
    options: [],
    correctIndex: -1,
    explanation: '答案：还是一群狼。'
  },
  {
    id: 297,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么数字倒立后会增加一半？',
    options: [],
    correctIndex: -1,
    explanation: '答案：6'
  },
  {
    id: 298,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '怎样才能把左手完全塞进右边裤袋，同时把右手完全塞进左边裤袋？',
    options: [],
    correctIndex: -1,
    explanation: '答案：把裤子前后反过来穿。'
  },
  {
    id: 299,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人在森林里迷路遇到真假话两个人，问\'如果我问另一个人哪条路是出路，他会怎么回答？\'然后走相反的路就能找到正确出路。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 300,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越分享越少？',
    options: ['快乐', '秘密', '知识', '爱'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 301,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西可以被听到却看不到摸不到？',
    options: [],
    correctIndex: -1,
    explanation: '答案：声音'
  },
  {
    id: 302,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么问题你永远只能回答“没有”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：“你睡着了吗？”'
  },
  {
    id: 303,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '如何让水瞬间变成冰？',
    options: [],
    correctIndex: -1,
    explanation: '答案：加两点水，变成“冰”字。'
  },
  {
    id: 304,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '哪个数字去掉最后一位变成40，去掉最前一位变成13？',
    options: [],
    correctIndex: -1,
    explanation: '答案：四十三'
  },
  {
    id: 305,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西剪不断，理还乱？',
    options: [],
    correctIndex: -1,
    explanation: '答案：愁绪'
  },
  {
    id: 306,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西你不看它，它却始终在看你？',
    options: [],
    correctIndex: -1,
    explanation: '答案：镜子'
  },
  {
    id: 307,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么时候十根手指加十根手指，还是十根手指？',
    options: [],
    correctIndex: -1,
    explanation: '答案：戴手套的时候。'
  },
  {
    id: 308,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么纸不用看就能知道上面的数字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：钞票'
  },
  {
    id: 309,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '有一个人，是你爸妈亲生的，却不是你的兄弟姐妹，他是谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：你自己'
  },
  {
    id: 310,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人一直往北走，最后却到了南方，为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：他在北极点，再往北走就变成向南了。'
  },
  {
    id: 311,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '谁整天笑眯眯，却从不是发自内心的笑？',
    options: [],
    correctIndex: -1,
    explanation: '答案：弥勒佛'
  },
  {
    id: 312,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一位卡车司机撞上了一辆摩托车，卡车司机受重伤，摩托车骑士却安然无恙。为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：卡车司机当时没开车，是走路时被撞的。'
  },
  {
    id: 313,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '有一艘船限载100人，已经上了99人，最后上船的是一个孕妇，船却沉了。为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为她是双胞胎，船上总人数变成了101人。'
  },
  {
    id: 314,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '医生给小明三颗药，吩咐他每半小时吃一颗。小明吃完需要多久？',
    options: [],
    correctIndex: -1,
    explanation: '答案：一小时。第一颗不需要等，现在吃，半小时后吃第二颗，再半小时后吃第三颗。'
  },
  {
    id: 315,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '两个人，一个面朝东，一个面朝西，不准回头，不准走动，不准照镜子，他们要怎样才能看到对方的脸？',
    options: [],
    correctIndex: -1,
    explanation: '答案：面对面站着'
  },
  {
    id: 316,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一张纸上画着一个箭头，箭头指向左边。你不准碰纸，不准加任何东西，如何让箭头指向右边？',
    options: [],
    correctIndex: -1,
    explanation: '答案：把纸翻过来，从背面看，或者转动纸张180度。'
  },
  {
    id: 317,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人掉进了湖里，当他被救上来时，全身都湿透了，头发却一点没湿。为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：他是秃头'
  },
  {
    id: 318,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个聋哑人去商店买钉子，他向售货员伸出两根手指（表示钉子）并用手做锤子敲打状。售货员给了他一把锤子，他摇摇头，指了指那两根手指，售货员才给了他钉子。接着进来一个盲人想买剪刀，请问盲人怎么做最快捷？',
    options: [],
    correctIndex: -1,
    explanation: '答案：直接开口说“我要买剪刀”。他是盲人，不是哑巴。'
  },
  {
    id: 319,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个男人看着一张照片说：“我没有兄弟姊妹，但这个人的父亲是我父亲的儿子。”照片上的人是谁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：他的儿子'
  },
  {
    id: 320,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '你在一个完全黑暗的房间里，只有一根蜡烛、一个煤油灯和一个木头火炉。你只有一根火柴，你会先点燃什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：火柴'
  },
  {
    id: 321,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个人把一枚硬币抛向空中，硬币落下后，正面朝上的概率是多少，如果他连续抛了99次都是反面？',
    options: [],
    correctIndex: -1,
    explanation: '答案：50%，每一次抛掷都是独立事件'
  },
  {
    id: 322,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越学越觉得自己无知？',
    options: [],
    correctIndex: -1,
    explanation: '答案：知识（苏格拉底悖论）'
  },
  {
    id: 323,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '怎样让一个不能弯曲的钢条迅速变弯曲，但你不能施加外力？',
    options: [],
    correctIndex: -1,
    explanation: '答案：扔进水里，水的折射会让它看起来弯曲。'
  },
  {
    id: 324,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一间锁着的房间里，小明死在地上，地上有碎玻璃和水。窗户是关着的，门是反锁的。小明是怎么死的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：小明是一条鱼，鱼缸被打碎了。'
  },
  {
    id: 325,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一个医生在紧急手术前，看到病人的脸，突然说：“他是我的儿子。”但医生并不是病人的父亲。这是怎么回事？',
    options: [],
    correctIndex: -1,
    explanation: '答案：医生是病人的母亲'
  },
  {
    id: 326,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '有一座房子，四面墙每面都朝南。一只熊从房子前走过，这只熊是什么颜色？',
    options: [],
    correctIndex: -1,
    explanation: '答案：白色。房子在北极点，所以是北极熊。'
  },
  {
    id: 327,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一位女士生了一对双胞胎，但两个孩子却出生在不同的年份。这是怎么发生的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：一个在除夕夜23:59出生，另一个在元旦00:00出生。'
  },
  {
    id: 328,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '一位老太太上了公交车，车上一个空位都没有。一个年轻人立刻站起来让座，但老太太却打了他一巴掌。为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：年轻人是司机，他站起来让座，车就失控了。'
  },
  {
    id: 329,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西越放松越容易得到？',
    options: [],
    correctIndex: -1,
    explanation: '答案：灵感'
  },
  {
    id: 330,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '如何在一秒内让世界消失？',
    options: [],
    correctIndex: -1,
    explanation: '答案：闭上眼睛'
  },
  {
    id: 331,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '麒麟到北极变成什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：冰淇淋'
  },
  {
    id: 332,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '布和纸最怕什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：不（布）怕一万，只（纸）怕万一'
  },
  {
    id: 333,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西载得动万吨重物，载不动一粒沙子？',
    options: [],
    correctIndex: -1,
    explanation: '答案：水'
  },
  {
    id: 334,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么数字最听话？',
    options: [],
    correctIndex: -1,
    explanation: '答案：100，百依百顺'
  },
  {
    id: 335,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '三人共撑一把伞走路，为何没人淋湿？',
    options: [],
    correctIndex: -1,
    explanation: '答案：没下雨'
  },
  {
    id: 336,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么东西浑身都是洞却能装水？',
    options: [],
    correctIndex: -1,
    explanation: '答案：海绵'
  },
  {
    id: 337,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '千里相逢打一字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：重'
  },
  {
    id: 338,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '四面都是山打一字？',
    options: [],
    correctIndex: -1,
    explanation: '答案：田'
  },
  {
    id: 339,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '为什么猴子最讨厌平行线？',
    options: [],
    correctIndex: -1,
    explanation: '答案：因为平行线没有“香蕉”（相交）'
  },
  {
    id: 340,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '什么水果最忙？',
    options: [],
    correctIndex: -1,
    explanation: '答案：芒果'
  },
  {
    id: 341,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.RIDDLE,
    title: '四个人一起打麻将，为何引来五个人？',
    options: [],
    correctIndex: -1,
    explanation: '答案：打的人叫麻将三、推理型问答【入门难度】'
  },
  {
    id: 342,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '一个正方形剪去一个角，一定还剩3个角。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 343,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '你有一桶果冻，其中有黄色、绿色、红色三种，闭上眼睛抓取，最少抓取多少个就可以确定你肯定有两个同一颜色的果冻？',
    options: [],
    correctIndex: -1,
    explanation: '答案：4个'
  },
  {
    id: 344,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '树上有10只鸟，猎人开枪打死了1只，还剩几只？',
    options: ['9只', '10只', '0只', '1只'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 345,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '小明比小红高，小红比小刚高，谁最矮？',
    options: ['小明', '小红', '小刚', '一样高'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 346,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '有3顶红帽子和2顶白帽子，甲、乙、丙三人各戴一顶，每人只能看到别人帽子的颜色，看不到自己的。老师依次问甲、乙、丙：“你知道自己帽子的颜色吗？”甲说：“不知道。”乙说：“不知道。”丙听完后说：“我知道了。”请问：丙戴的帽子是什么颜色？',
    options: ['红色', '白色', '无法确定', '以上都不对'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 347,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人中，只有一个人是罪犯。他们分别说了以下三句话：甲说：“乙是罪犯。”乙说：“我不是罪犯。”丙说：“甲不是罪犯。”已知只有一个人说了真话。请问：罪犯是谁？',
    options: ['甲', '乙', '丙', '无法确定'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 348,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人参加数学竞赛，成绩分别为 100 分、90 分、80 分（三人分数各不相同）。他们分别说了一句话：甲说：“我不是最高分。”乙说：“我不是最低分。”丙说：“甲不是最低分。”已知三人中 只有一个人说了真话。请问：谁得了 100 分？',
    options: [],
    correctIndex: -1,
    explanation: '答案：甲'
  },
  {
    id: 349,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '池塘里的睡莲每天长大一倍，10天长满整个池塘，第5天长满一半。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 350,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '农夫带狼、羊、菜过河，第一步应该先带羊过去。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 351,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '1个人吃1个苹果需要3分钟，3个人同时吃3个苹果需要几分钟？',
    options: ['9分钟', '6分钟', '3分钟', '1分钟'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 352,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人中，一人是班长，一人是学习委员，一人是体育委员。他们分别说了以下三句话：甲说：“乙是班长。”乙说：“我不是学习委员。”丙说：“甲不是体育委员。”已知三人中 只有一个人说了真话。请问：谁是班长？',
    options: ['甲', '乙', '丙', '无法确定'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 353,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '小明从1楼爬到3楼用了4分钟，爬到6楼需要几分钟？',
    options: [],
    correctIndex: -1,
    explanation: '答案：10分钟'
  },
  {
    id: 354,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '有红、黄、蓝三顶帽子，甲、乙、丙三人各戴一顶。他们知道帽子只有三种颜色，且每种颜色只有一顶。甲说：“我看到乙戴的不是红帽。”乙说：“我看到丙戴的是黄帽。”丙说：“我看到甲戴的是蓝帽。”已知三人中 只有一人说了真话，请问：甲戴的是什么颜色的帽子？',
    options: ['红色', '黄色', '蓝色', '无法确定'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 355,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '一根绳子对折一次后从中间剪断，会变成几段？',
    options: ['2段', '3段', '4段', '5段'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 356,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '所有的偶数都能被2整除。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 357,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '时钟敲3下用了6秒，敲6下需要几秒？',
    options: [],
    correctIndex: -1,
    explanation: '答案：15秒'
  },
  {
    id: 358,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ENTRY,
    topic: Topic.REASONING,
    title: '三角形的外角和等于180度。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 359,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有一个数，除以3余2，除以5余3，除以7余2，这个数最小是多少？',
    options: ['23', '53', '128', '233'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 360,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一群人开舞会，每人戴黑白帽子，黑的至少一顶。第三次关灯才有打耳光声，有几顶黑帽子？',
    options: ['2顶', '3顶', '4顶', '5顶'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 361,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一本书的页码从1到100，数字\'1\'出现了多少次？',
    options: ['10次', '19次', '20次', '21次'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 362,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一个人在沙漠里头朝下死了，身边散落行李，手里抓着半个火柴。他是从热气球上被扔下来的。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 363,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人分别住在 1 层、2 层、3 层楼。已知：甲不住 1 层；乙不住 2 层；丙不住 3 层；甲和乙的楼层号相差 1。由此可以推出：甲住在 3 层。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 364,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '抛一枚硬币，前9次都是正面，第10次正面的概率还是1/2。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 365,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一根绳子对折再对折，从中间剪一刀，绳子变成几段？',
    options: [],
    correctIndex: -1,
    explanation: '答案：5段'
  },
  {
    id: 366,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有12个乒乓球，其中一个重量不同不知轻重，用天平最少称几次能找出并知轻重？',
    options: ['2次', '3次', '4次', '5次'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 367,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一间牢房两个犯人分汤，一个人分另一个人选就公平了。现在三个犯人怎么分最公平？',
    options: [],
    correctIndex: -1,
    explanation: '答案：甲分三份，乙丙先选，剩下的给甲；然后乙丙的汤合在一起再按两人分法分'
  },
  {
    id: 368,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '你有两个罐子，50红50蓝弹球，随机选罐随机取球，怎么给红球最大选中机会？',
    options: [],
    correctIndex: -1,
    explanation: '答案：一罐放1个红球，另一罐放49红50蓝'
  },
  {
    id: 369,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '3个人3天喝3桶水，9个人9天喝几桶水？',
    options: ['9桶', '18桶', '27桶', '81桶'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 370,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '甲、乙、丙、丁四人排成一排照相。已知：甲不站在两端；乙站在丙的左边（不一定相邻）；丁不站在乙的右边；丙站在丁的左边。请问：谁站在最左边？',
    options: ['甲', '乙', '丙', '丁'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 371,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人中只有一人会开车。甲说：\'我会开车。\'乙说：\'我不会开车。\'丙说：\'甲不会开车。\'如果三人中只有一人说的是真话，那么谁会开车？',
    options: ['甲', '乙', '丙', '无法确定'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 372,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '5个海盗分100金币，1号先提方案，超过半数同意才通过，否则扔下去。1号最优方案是什么？',
    options: ['每人20个', '(97,0,1,2,0)', '(50,50,0,0,0)', '(34,33,33,0,0)'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 373,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有4个人要过桥，只有一个手电筒，每次最多过两人，走得快的要等走得慢的。四人过桥时间分别是1、2、5、10分钟，最少需要几分钟？',
    options: [],
    correctIndex: -1,
    explanation: '答案：17分钟'
  },
  {
    id: 374,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一个房间有3盏灯，门外有3个开关，只能进去一次，怎么确定哪个开关对应哪盏灯？',
    options: ['不可能', '利用温度，先开一盏等会儿关掉再开另一盏', '靠运气', '要进去两次'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 375,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一个正方形剪去一个角，可能剩下3个、4个或5个角。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 376,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '甲、乙、丙、丁四人从左到右站成一排。已知：甲不站在第 1 位；乙站在丙的右边（不一定相邻）；丁站在甲的左边（不一定相邻）；丙不站在第 4 位。由此可以推出：丁一定站在第 1 位。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 377,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '1元钱一瓶汽水，两个空瓶换一瓶，20元最多喝几瓶？',
    options: ['38瓶', '39瓶', '40瓶', '41瓶'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 378,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有8个球，其中一个较重，用天平最少称几次能找出？',
    options: [],
    correctIndex: -1,
    explanation: '答案：2次'
  },
  {
    id: 379,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '烧一根不均匀的绳要用一小时，如何判断半个小时？',
    options: [],
    correctIndex: -1,
    explanation: '答案：同时点燃两端'
  },
  {
    id: 380,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有红、黄、蓝三个盒子，其中一个盒子里有礼物。红盒子写\'礼物不在此盒中\'，黄盒子写\'礼物在红盒子中\'，蓝盒子写\'礼物不在此盒中\'。如果三句话中只有一句是真的，礼物在哪个盒子里？',
    options: ['红盒子', '黄盒子', '蓝盒子', '无法确定'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 381,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有两根材质不均匀的绳子，每根绳子从一头点燃，烧完都恰好需要 60 分钟。现在给你一个打火机，如何用这两根绳子测量出 45 分钟？（不能剪断、不能折叠，只能点燃）',
    options: [],
    correctIndex: -1,
    explanation: '答案：第一根绳子两头同时点燃，同时第二根绳子只点燃一头，第一根烧完后点燃第二根另一头。'
  },
  {
    id: 382,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有25匹马，每次最多5匹比赛，最少赛几次能找出最快的3匹？',
    options: ['5次', '6次', '7次', '8次'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 383,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '如果天下雨，那么地面一定潮湿。现在地面是潮湿的，所以天一定下过雨了。这个推理是否正确？',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 384,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '瞎子侏儒自杀是因为另一个侏儒把他家家具腿锯短了，让他以为自己长高了。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 385,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有三个盒子分别装着两个红球、两个蓝球、一红一蓝，标签全错了。从哪个盒子拿一个球就能判断全部？',
    options: ['两红标签的盒子', '两蓝标签的盒子', '一红一蓝标签的盒子', '哪个都不行'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 386,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一位老人有 17 匹马，他临终前立下遗嘱：老大分得总数的 1/2，老二分得总数的 1/3，老三分得总数的 1/9，并且马不能宰杀。请问三个儿子该如何分马？',
    options: [],
    correctIndex: -1,
    explanation: '答案：先借来 1 匹马，使总数变成 18 匹。'
  },
  {
    id: 387,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有1000瓶药水，一瓶有毒，老鼠喝了一周后死。给一周时间，最少需要多少只老鼠？',
    options: ['5只', '10只', '20只', '100只'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 388,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有三扇门，一扇后有汽车两扇后有山羊。你选一扇，主持人打开另一扇有山羊的，换不换？中奖概率分别是多少？',
    options: [],
    correctIndex: -1,
    explanation: '答案：换，换门中奖概率2/3，不换1/3'
  },
  {
    id: 389,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '农夫带狼、羊、菜过河，船只能载一样，狼吃羊、羊吃菜，怎么过？',
    options: [],
    correctIndex: -1,
    explanation: '答案：先带羊过去，回来；带狼过去，带羊回来；带菜过去，回来；最后带羊过去'
  },
  {
    id: 390,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有两个水桶，5升和3升，怎样量出4升水？（简述一种方法）',
    options: [],
    correctIndex: -1,
    explanation: '答案：5升装满倒满3升，5升剩2升；把3升倒掉，把2升倒进3升；再装满5升，倒满已有2升的3升桶，5升桶剩4升'
  },
  {
    id: 391,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '10层楼梯，每次走1或2级，一共有55种走法。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 392,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人中至少有一人是罪犯。已知：如果甲是罪犯，那么乙不是罪犯；当且仅当丙不是罪犯时，甲是罪犯。由此可以推出：乙一定是罪犯。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 393,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有两个房间，一个房间里有三盏灯（分别标记为 A、B、C），另一个房间里有三个开关（分别标记为 1、2、3），每个开关只控制一盏灯，但你无法从开关房间看到灯。你只能进入灯的房间 一次，出来后就再也不能进去。请问：如何只进灯房一次，就能准确判断出每个开关分别控制哪盏灯？',
    options: [],
    correctIndex: -1,
    explanation: '答案：先在开关房，打开开关 1，等几分钟（让对应的灯发热），然后 关掉开关 1。接着 打开开关 2，并保持打开状态。最后进入灯房，观察三盏灯：亮着的灯 → 由开关 2 控制；不亮但摸上去发热的灯 → 由开关 1 控制（因为之前开过一段时间，关了但余热还在）；不亮且不热的灯 → 由开关 3 控制（从未打开过）。'
  },
  {
    id: 394,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '已知“P 是 Q 的充分条件”和“Q 是 R 的必要条件”这两个命题为真，那么可以推出“P 是 R 的充分条件”也为真。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 395,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '已知以下四个命题为真：（1）如果甲是罪犯，那么乙是罪犯；（2）如果乙是罪犯，那么丙是罪犯；（3）如果丙是罪犯，那么丁是罪犯；（4）甲或丁是罪犯。问：以下哪项一定为真？',
    options: ['甲是罪犯', '乙是罪犯', '丙是罪犯', '丁是罪犯'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 396,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有10瓶药，每瓶里有100粒药丸，正常药丸每粒重1克，但其中有一瓶里的药丸全被替换成了假药，假药每粒重0.9克。现在给你一台精确电子秤（可以称出具体重量），只准称一次，如何确定哪一瓶是假药？',
    options: [],
    correctIndex: -1,
    explanation: '答案：给10瓶药编号为1~10。从第1瓶取1粒，第2瓶取2粒，……，第10瓶取10粒，一共取 55 粒。把这55粒一起称重。如果全是真药，总重量应为 55 克。实际称出的重量会比55克少几个0.1克，少几个0.1克，就说明取了几粒假药，而假药来自哪一瓶，就对应编号。例如，少0.3克，说明有3粒假药，即从第3瓶取的，所以第3瓶是假药。'
  },
  {
    id: 397,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '某种罕见病在人群中的发病率为 0.1%。有一种检测方法，对于患病者检测出阳性的准确率为 99%（即灵敏度），对于未患病者检测出阴性的准确率也为 99%（即特异度）。现在某人做了一次检测，结果显示为阳性。那么，此人实际患病的概率约为 99%。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 398,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '一个池塘的睡莲每天长大一倍，15天长满整个池塘，第几天长满一半？',
    options: ['7天', '10天', '14天', '15天'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 399,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有一个 8×8 的国际象棋棋盘（共 64 个格子，黑白相间）。现在把棋盘左上角和右下角两个格子（这两个格子颜色相同）去掉，剩下 62 个格子。请问：能否用 31 块 1×2 的多米诺骨牌（每块恰好覆盖两个相邻格子，一黑一白）将这 62 个格子完全覆盖？为什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：不能。因为：完整棋盘有 32 个黑格和 32 个白格。去掉左上角和右下角后，因为这两个角颜色相同（都是黑格或都是白格，国际象棋棋盘对角同色），所以去掉后，一种颜色剩下 30 个，另一种颜色剩下 32 个。而每块 1×2 的多米诺骨牌必然覆盖一个黑格和一个白格，因此要完全覆盖，必须要求黑白格数量相等。现在不等（30 ≠ 32），所以不可能做到。'
  },
  {
    id: 400,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '三个人去住旅馆，一晚 30 元。三人各掏了 10 元凑够 30 元交给老板。后来老板说今天优惠只要 25 元，于是拿出 5 元让服务员退还给客人。服务员偷偷藏起了 2 元，把剩下的 3 元退给三人，每人分到 1 元。这样一来，一开始每人掏了 10 元，现在退回 1 元，相当于每人只花了 9 元。三人一共花了 27 元，再加上服务员藏起的 2 元，总共是 29 元。请问：还有 1 元钱去了哪里？',
    options: [],
    correctIndex: -1,
    explanation: '答案：1 元钱并没有消失，是计算方式故意搞混了“支出”和“收入”。三个人实际支出的总金额是 27 元（25 元房费 + 2 元被服务员藏起）。这 27 元里已经包含了服务员拿走的 2 元。正确的等式应该是：三人实际支出 27 元 + 退回的 3 元 = 30 元。而题目中用“27 元 + 2 元”纯粹是把已经包含在内的 2 元又重复加了一遍，属于逻辑混淆，所以不存在“少了 1 元”的问题。'
  },
  {
    id: 401,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '两个圆环半径1和2，小圆在大圆内部绕一周，小圆自身转几周？',
    options: [],
    correctIndex: -1,
    explanation: '答案：1周'
  },
  {
    id: 402,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '甲、乙、丙、丁、戊五人围坐在一张圆桌旁（五人等距，顺时针方向为“右边”）。已知：甲坐在乙的右边（即甲与乙相邻，且甲在乙的顺时针方向）；丙坐在丁的左边（即丙与丁相邻，且丙在丁的逆时针方向）；戊坐在甲和丙之间（即戊同时与甲和丙相邻）。问：谁坐在丁的正对面？',
    options: ['甲', '乙', '丙', '戊'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 403,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '有一口井深7米，蜗牛白天爬3米晚上坠2米，几天能爬出来？',
    options: ['5天', '7天', '4天', '6天'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 404,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '在一个岛上住着100个人，他们的眼睛颜色只有蓝色和棕色两种。岛上的居民都知道，至少有一个人的眼睛是蓝色的，但是他们不能谈论眼睛颜色，也不能照镜子或通过任何方式知道自己的眼睛颜色。每个人都能看到别人的眼睛颜色，但看不到自己的。他们每天白天集体聚集，如果某人能确定自己的眼睛是蓝色，他会在当晚自杀。假设所有居民都是逻辑完美的，并且都严格遵守规则。过了几天，有一天晚上，所有蓝眼睛的人一起自杀了。已知岛上有5个蓝眼睛的人，请问：这是在过后的第几天发生的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：第5天'
  },
  {
    id: 405,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.ADVANCED,
    topic: Topic.REASONING,
    title: '绳子对折3次从中间剪断会变成9段。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 406,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在一个集合族中，如果任意两个集合都有交集，那么整个集合族的所有集合交集一定非空。',
    options: ['对', '错'],
    correctIndex: 1,
    explanation: '正确答案：错'
  },
  {
    id: 407,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在博弈论中的“百囚犯问题”中，若采用“循环追踪”策略，100个囚犯全部获释的概率约为31%。百囚犯问题背景：100 名囚犯每人都有一个编号（1-100），编号被随机放入 100 个盒子中，每人最多只能打开 50 个盒子。只有当所有囚犯都找到自己的编号时，才能全部获释。循环追踪策略：每个囚犯从标有自己编号的盒子开始打开，根据盒子里的编号打开下一个盒子，依此类推。这个过程会形成一个循环。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 408,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '蒙提霍尔问题（三门问题）中，换门的中奖概率是多少？\n题目背景：蒙提霍尔问题（又称三门问题），源自美国电视游戏节目《Let\'s Make a Deal》，以主持人蒙提・霍尔的名字命名。游戏规则如下：参赛者面前有三扇关闭的门，其中一扇门后藏有一辆汽车（中奖），另外两扇门后各藏有一只山羊（不中奖）。参赛者先选定一扇门，主持人（知道每扇门后的情况）会从另外两扇门中打开一扇藏有山羊的门，然后给参赛者一次 “换另一扇门” 的机会。',
    options: ['1/2', '1/3', '2/3', '3/4'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 409,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '商人运胡萝卜问题，最多能卖出533斤胡萝卜。\n题目背景：一个商人骑一头驴要穿越 1000 公里长的沙漠，去卖 3000 根胡萝卜。已知驴一次性最多可驮 1000 根胡萝卜，但每走 1 公里又要吃掉 1 根胡萝卜。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 410,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '蓝眼睛岛问题的核心推理方法是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：数学归纳法'
  },
  {
    id: 411,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '隔板法适用于什么问题？',
    options: ['不同元素分组', '相同元素分组，每组至少一个', '排列问题', '概率问题'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 412,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '兄弟俩买书，哥哥缺5元弟弟缺1分，合买还不够，书多少钱？',
    options: ['4.99元', '5元', '5.01元', '10元'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 413,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '岛上住着100个蓝眼睛和100个棕眼睛。外来者当众说：“我看到了至少一个蓝眼睛。”已知所有人绝对理性且不能讨论眼睛颜色。请问第几天晚上会发生什么？如果外来者说的是“我看到了至少两个蓝眼睛”，结果会如何变化？\n题目背景：原蓝眼睛岛问题是一个经典的归纳逻辑谜题，原题描述如下：一座岛上住着 1000 个居民，其中 100 人是蓝眼睛，900 人是棕眼睛。岛上有严格的规则：1. 他们不能照镜子、不能交流眼睛颜色，也不知道自己的眼睛颜色。2. 一旦有人知道自己是蓝眼睛，就必须在当天中午当众离开岛屿。3. 所有岛民都极其聪明、遵守规则，且知道其他人也同样聪明、遵守规则。某天，一位外来者来到岛上，当着所有人的面说了一句话：“我看到岛上有蓝眼睛的人。”',
    options: [],
    correctIndex: -1,
    explanation: '答案：如果外来者说至少一个，第100天蓝眼睛集体离开，棕眼睛第101天离开（因为他们意识到自己不是蓝）。若说至少两个，则蓝眼睛会在第99天离开（因为每个蓝看到99个蓝，若自己不是蓝，则那99人应在第99天离开，没发生时，第100天离开，其实规则变了，标准解：N个蓝说至少1个，第N天离开。说至少2个，等价于N-1个的版本，即第N-1天离开）。'
  },
  {
    id: 414,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一条鳄鱼偷走了母亲的孩子，它对母亲说：“如果你能猜对我是否会吃掉孩子，我就把孩子还给你。”母亲说：“你会吃掉我的孩子。”请问鳄鱼该怎么做才能不违背自己的承诺？',
    options: [],
    correctIndex: -1,
    explanation: '答案：这是一个自指悖论。如果鳄鱼吃掉孩子，那么母亲猜对了，按照承诺应该归还，矛盾；如果归还孩子，母亲猜错了，按照承诺应该吃掉，矛盾。所以逻辑上无解，鳄鱼无法在不违背承诺的情况下行动。'
  },
  {
    id: 415,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '蓝眼睛岛问题中，第n天有n个蓝眼睛的人一起离开。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 416,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一个超级智能存在者能准确预测你的选择。面前有两个盒子，A透明，放着1000美元；B不透明，要么放100万美元，要么空。你可以选择只拿B，或者两个都拿。存在者在你选择前预测你的行为：如果预测你只拿B，就放100万进B；如果预测你两个都拿，就放0进B。已知预测准确率99.9%。你应该选择只拿B还是两个都拿？',
    options: [],
    correctIndex: -1,
    explanation: '答案：这是博弈论与决策论的经典冲突。依据“占优策略”，无论B里有没有，两个都拿总比只拿B多1000美元，所以应拿两个。但依据“期望效用”，只拿B几乎稳拿100万，应只拿B。本题无标准答案，取决于你信奉“因果决策论”还是“证据决策论”。'
  },
  {
    id: 417,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '村子100对夫妻，每个丈夫都不忠，妻子知道别人丈夫不忠不知道自己的。村长说至少一个不忠，会发生什么？',
    options: ['什么都不发生', '第一天有一对夫妻离婚', '第100天所有夫妻全部离婚', '只有一对夫妻会离婚'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 418,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '牧场草匀速生长，27头牛6天吃完，23头牛9天吃完，21头牛几天吃完？',
    options: ['10天', '12天', '14天', '15天'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 419,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '生日悖论中，23个人至少两人生日相同的概率超过50%。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 420,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '100个囚犯，一个开关房，里面有一个灯泡，初始状态未知（亮或灭）。每天随机抽一个囚犯进房，他必须开或关灯，或者什么都不做。只要有人宣布“所有人都进过房”并且正确，所有人释放。请设计一个策略保证释放。',
    options: [],
    correctIndex: -1,
    explanation: '答案：选一个“计数员”。其他囚犯：第一次看到灯灭时，打开灯，并且此后不再开灯；看到灯亮则不动。计数员：每次看到灯亮就关灯，并计数，当他数到99次时，宣布所有人进过房。'
  },
  {
    id: 421,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '100个囚犯问题中，循环查找策略可以让存活率达到约31%。\n题目背景：100 个囚犯问题是一个经典的概率与算法谜题，原题描述如下：有 100 名囚犯，每人编号 1 到 100。编号被随机放入 100 个编号为 1 到 100 的盒子中，每个盒子放一个编号。囚犯们轮流进入房间，每人最多打开 50 个盒子，如果找到自己的编号，则成功；如果所有囚犯都成功，全体获释；只要有一人失败，全体处决。囚犯们在进入房间前可以讨论策略，但进入后不能交流。核心策略：循环查找策略每个囚犯都遵循以下规则：1. 从标有自己编号的盒子开始打开；2. 取出盒子里的编号，接着打开标有这个编号的盒子；3. 重复步骤 2，直到找到自己的编号，或者打开了 50 个盒子。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 422,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '商人有3000斤胡萝卜，驴一次驮1000斤，每公里吃1斤，运到1000公里外最多卖多少斤？',
    options: ['0斤', '333斤', '533斤', '1000斤'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 423,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '牛吃草问题的关键是什么？\n题目背景：牛吃草问题（又称牛顿问题），是由牛顿在《普通算术》中提出的经典数学模型，核心是解决 “总量随时间动态变化” 的问题。原题描述通常为：牧场上的草在匀速生长，牛一边吃草，草一边在长，需要计算不同数量的牛吃完草所需的时间。',
    options: ['草的总量固定', '草在匀速生长，要算原有草量和生长速度', '牛的数量变化', '时间不固定'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 424,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '将一个8×8的棋盘切成四块（两个直角梯形和两个直角三角形），重新拼成一个5×13的矩形。8×8面积64，5×13面积65。请问多出的1个单位面积从哪来的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：利用了斐波那契数列的斜率差。拼合时，两个三角形的斜边斜率不同（3/8 和 2/5），拼成的“矩形”中间有一条极其细的缝隙（或重叠），面积正好是1，实际上并不是一个真正的矩形，那条缝隙的面积就是1。'
  },
  {
    id: 425,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '三个人A、B、C，其中一人将被处死，另两人将被释放。A问狱警：“告诉我B和C中谁会被释放？”狱警说：“B会被释放。”问A被处死的概率现在变为多少？（已知狱警不说谎，且如果B和C都会被释放，他会随机说一个名字。）',
    options: [],
    correctIndex: -1,
    explanation: '答案：A被处死的概率依然是1/3，而不是1/2。因为狱警的话提供了条件概率。C被处死的概率变为2/3。'
  },
  {
    id: 426,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一家有无数个房间的旅馆已经住满（每个房间一人）。现又来了一位新客人，老板如何安排？如果来了无穷多个（可数）客人，又该如何安排？',
    options: [],
    correctIndex: -1,
    explanation: '答案：让原来1号房的客人搬到2号，2号搬到3号，以此类推，空出1号给新客人。若来无穷多个客人，让原来n号房的客人搬到2n号房，空出所有奇数号房给新来的无穷多客人。'
  },
  {
    id: 427,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '两个玻璃球找临界楼层问题的最优解思想是什么？\n题目背景：两个玻璃球找临界楼层问题是经典的算法与逻辑谜题，原题描述如下：有一栋 100 层的大楼，和两个一模一样的玻璃球。玻璃球从某一层（临界层）或更高的楼层扔下就会摔碎，低于临界层则不会碎。你需要用最少的尝试次数，找到这个临界楼层。规则：玻璃球摔碎后就不能再用了；你可以根据前一次的结果调整下一次的测试楼层。',
    options: [],
    correctIndex: -1,
    explanation: '答案：让最坏情况下总次数相等'
  },
  {
    id: 428,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '100个球中有一个较轻，用天平最少称几次能找出？',
    options: [],
    correctIndex: -1,
    explanation: '答案：5次'
  },
  {
    id: 429,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '两个玻璃球找100层楼临界楼层，最坏情况最少需要14次。\n题目背景：这是经典的双蛋问题（两个玻璃球找临界楼层），原题设定如下：有一栋 100 层的大楼，和两个一模一样的玻璃球。玻璃球从某层（临界层）及以上扔下会摔碎，低于该层则不会损坏。目标：用最少的尝试次数，找到这个临界楼层，且需考虑最坏情况。限制：玻璃球摔碎后无法再次使用。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 430,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '给你两个信封，里面都有钱，且已知一个信封里的钱是另一个的2倍。你随机选了一个打开，看到里面是100元。问：换另一个信封的期望收益是多少？是否应该换？',
    options: [],
    correctIndex: -1,
    explanation: '答案：设另一个为50或200各1/2概率，期望=0.5*50+0.5*200=125>100，似乎该换。但对称性导致矛盾（如果打开前换与不换无差别）。此悖论在于概率分配无法确定（因为你先验不知道总钱数，无法定义等概率分布）。'
  },
  {
    id: 431,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有 100个囚犯 排成一列，面朝前方（即第一个人在最前面，最后一个人在最后面）。狱卒给每人随机戴上一顶帽子，帽子只有 黑色 或 白色 两种颜色（每个囚犯都能看到 前面所有人 的帽子颜色，但看不到自己的，也看不到后面的人的）。现在从 最后一个人 开始，依次大声说出一个颜色（“黑”或“白”）。说对的人被释放，说错的人被处死。在开始之前，囚犯们可以商量一个策略，但一旦开始，除了报颜色之外不能传递任何其他信息（比如语气、停顿等）。问： 他们最多能保证（即无论帽子如何分布）有多少人获救？请给出具体策略，并说明为什么。',
    options: [],
    correctIndex: -1,
    explanation: '答案：最多能保证 99 个人获救（最后一个人可能牺牲，但其余99人都能准确说出自己的帽子颜色）。'
  },
  {
    id: 432,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '10个袋子各10金币，9袋足量10g，1袋每袋9g，最少称几次能找出不足量的袋子？',
    options: ['1次', '2次', '3次', '10次'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 433,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '无穷多个囚犯排成一列（1,2,3...），每人戴黑帽或白帽。从第1个开始，每个人都能看到前面所有人（编号比他小）的帽子颜色。从最后一个开始问颜色，问是否能保证只有有限个人答错？（允许囚犯们提前商量策略，必须用选择公理。）',
    options: [],
    correctIndex: -1,
    explanation: '答案：能。利用选择公理，将无穷长的0-1序列按“等价关系”分类（两序列若从某一项之后完全相同，则等价）。囚犯们事先约定从每个等价类中选一个代表序列。队列中的人从后往前看，看不到后面的人，但可以看到前面的人，他需要推断整个序列属于哪个等价类，然后回答自己对应位置在代表序列中的颜色。因为真实序列与代表序列只在有限项不同，所以只有有限个人答错。'
  },
  {
    id: 434,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '方阵问题中，最外层每边n人，最外层共多少人？\n题目背景：方阵问题是小学奥数和行测中常见的一类几何计数问题，通常描述为：一群人排成一个正方形队列，每边有 n 个人，需要计算队列最外层的总人数。',
    options: ['4n人', '4n-4人', 'n²人', '4n+4人'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 435,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '甲、乙、丙、丁四人进行乒乓球单打比赛，每两人之间都要比赛一场。已知甲胜了丁，且甲、乙、丙三人胜的场数相同。问丁胜了几场？',
    options: ['0场', '1场', '2场', '3场'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 436,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在“蒙提霍尔”问题中，如果主持人随机开门（他不知道门后有什么，碰巧打开了羊门），那么此时换门的中奖概率是1/2。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 437,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有9枚硬币，其中一枚是假币，假币可能偏重也可能偏轻。现有一架无砝码的天平，最少称几次一定能找出假币并判断其轻重？请给出详细步骤。',
    options: [],
    correctIndex: -1,
    explanation: '答案：3次。分成3组（A、B、C各3枚）。称A vs B。若平衡，假币在C，称C1 vs C2，若平衡则C3是假，再称C3 vs A1判轻重；若不平衡，则C1或C2假，根据轻重可知。若A vs B不平衡，设A重B轻，则称A1B1B2 vs A2A3B3（需详细推导），3次足够。'
  },
  {
    id: 438,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有一个诚实国和说谎国。诚实国的人永远说真话，说谎国的人永远说假话。你遇到A和B两个人。A说：“我们俩都是说谎国的。”B说：“我是诚实国的。”问A和B分别是什么国家的人？',
    options: ['A诚实，B说谎', 'A说谎，B诚实', '都是诚实', '都是说谎'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 439,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '3个开关对应3盏灯，房间外看不到里面，只能进去一次，能确定对应关系吗？',
    options: ['不能', '能，利用温度', '能，靠运气', '要进去两次'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 440,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '三个牧师和三个魔鬼要过河，只有一条小船，一次最多坐两个人。无论在河的哪一边，如果魔鬼数量多于牧师数量，牧师就会被吃掉。请问如何过河？',
    options: [],
    correctIndex: -1,
    explanation: '答案：1. 两鬼过河，一鬼回；2. 两鬼过河，一鬼回；3. 两牧师过河，一牧一鬼回；4. 两牧师过河，一鬼回；5. 两鬼过河，一鬼回；6. 两鬼过河。（全过）'
  },
  {
    id: 441,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '3个犯人戴黑帽子，国王说看到两个白帽子或知道自己黑帽子就释放。三人都是黑帽子，聪明的A能推断出来吗？用什么方法？',
    options: [],
    correctIndex: -1,
    explanation: '答案：能，用反证法推理'
  },
  {
    id: 442,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '时钟问题中，分针每分钟走多少度？',
    options: ['6度', '30度', '0.5度', '10度'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 443,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在“囚徒困境”的单次博弈中，无论对方如何选择，选择“背叛”都是个体最优策略，因此纳什均衡是（背叛，背叛）。\n题目背景：囚徒困境是博弈论中最经典的非零和博弈模型，原题设定如下：两个嫌疑人被警方逮捕，分别关押，无法沟通。警方给出的选择如下：如果两人都**沉默（合作），都只判 1 年；如果一人沉默、一人背叛，背叛者立即释放，沉默者判 10 年；如果两人都背叛，都判 5 年。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 444,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '7分钟和4分钟沙漏，怎么准确测出9分钟？',
    options: [],
    correctIndex: -1,
    explanation: '答案：同时启动7分钟沙漏和4分钟沙漏。4分钟漏完时立即翻转4分钟沙漏。7分钟漏完时（已过7分钟），4分钟沙漏还剩1分钟，此时立即翻转7分钟沙漏。等4分钟沙漏漏完（此时共8分钟），立即再翻转7分钟沙漏（它里面只有1分钟的沙）。等7分钟沙漏再漏完，即得到9分钟。'
  },
  {
    id: 445,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '甲乙两人从相距100千米的两地相向而行，甲每小时走6千米，乙每小时走4千米。甲带一只狗，狗每小时跑10千米，狗和甲一起出发，碰到乙时掉头往甲跑，碰到甲又往乙跑，直到两人相遇。问狗一共跑了多少千米？',
    options: ['80千米', '100千米', '120千米', '150千米'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 446,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一个村子里有50对夫妻。某天，外来者说：“这里至少有一个丈夫出轨了。”如果一个妻子知道了自己丈夫出轨，夫妻就会离婚。假设所有妻子都极度聪明，且出轨事实客观存在。如果前49天晚上都没有夫妻离婚，第50天晚上会发生什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：第50天晚上，50对夫妻全部离婚。'
  },
  {
    id: 447,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '考虑所有实数，将[0,1]区间内的实数一一枚举排列（假设可以）。构造一个数x，其第n位小数与第n个数第n位小数不同。这个x不在枚举列表里，说明实数不可数。请问这个证明中哪里用到了“排中律”和“选择公理”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：对角线证明不需要选择公理，因为每一位的取值是确定的（选0或1），只需要排中律（每个位置要么相同要么不同）。它证明了实数集与自然数集不等势。'
  },
  {
    id: 448,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '5个海盗分100金币，1号提议，如果超过半数（含半数？）同意则通过，否则扔海。1号为了保命并最大化，方案是什么？如果必须超过半数（不含半数）呢？',
    options: [],
    correctIndex: -1,
    explanation: '答案：若含半数（1人时1票即过），答案(98,0,1,0,1)。若超过半数（严格大于半数），答案(97,0,1,0,2)或(97,0,1,2,0)（取决于4号5号谁更关键）。'
  },
  {
    id: 449,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '西瓜切9刀最多能切成多少份？',
    options: ['45份', '90份', '130份', '512份'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 450,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '6升和4升的杯子，能量出3升水吗？',
    options: ['能', '不能', '不确定', '要看杯子形状'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 451,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有编号为1、2、3的三张扑克牌（牌面数字各不相同）每张牌要么是红桃，要么是黑桃。已知： 如果1号是红桃，那么2号是黑桃。 如果2号是红桃，那么1号是黑桃。 3号不是红桃。 问：以下哪项一定为真？',
    options: ['1号是黑桃', '2号是红桃', '3号是黑桃', '1号是红桃'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 452,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在5×5的棋盘上，至少要放5个棋子，才能保证任意一行、任意一列都至少有一个棋子。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 453,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '圆形水池猫在岸边追老鼠，猫速是鼠速4倍，老鼠能逃脱吗？',
    options: ['不能', '能，先游到圆心再朝反方向游', '不一定', '要看水池大小'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 454,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '6升和4升的杯子不能量出3升水，因为最大公约数是2。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 455,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '甲乙丙三人玩猜数字游戏，数字范围是1到10。甲说：“我猜的数字是质数。”乙说：“我猜的数字是偶数。”丙说：“我猜的数字是3的倍数。”已知他们三人中恰好有两个人猜对了，并且这三个数字各不相同。则甲7，乙6，丙9不可能出现。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 456,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有红、蓝、黄、白四种颜色的帽子各一顶，甲、乙、丙、丁四人各戴一顶。甲说：“我戴的不是红帽。”乙说：“丙戴的是黄帽。”丙说：“我戴的不是白帽。”丁说：“甲戴的是蓝帽。”已知四人中只有一人说真话，问谁戴红帽？',
    options: ['甲', '乙', '丙', '丁', '无法确定'],
    correctIndex: 4,
    explanation: '正确答案：E'
  },
  {
    id: 457,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在集合 {1,2,3,...,100} 中，至少要取多少个数(盲取），才能保证其中一定有两个数之和为101？',
    options: ['50', '51', '52', '100'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 458,
    type: QuestionType.TRUE_FALSE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '四人过桥问题最优解需要17分钟。\n题目背景：四人过桥问题是经典的逻辑优化谜题，原题设定如下：夜晚有 4 个人需要过桥，桥每次最多过 2 人，且必须带着手电筒照明。4 个人单独过桥的时间分别是：1 分钟、2 分钟、5 分钟、10 分钟。两人一起过桥的时间按较慢的那个人算，且过桥后必须有人把手电筒送回来。目标是用最少的时间让所有人过桥。',
    options: ['对', '错'],
    correctIndex: 0,
    explanation: '正确答案：对'
  },
  {
    id: 459,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在无限次重复的囚徒困境中，采用“以牙还牙”策略（第一轮先合作，之后复制对方上一轮动作）在什么条件下能构成纳什均衡？\n题目背景：两名犯人被分开审讯，无法串通，警方给出坦白、沉默两种选择，对应不同刑期。规则收益：都沉默：两人均轻判；一人坦白一人沉默：坦白者无罪释放，沉默者重判；都坦白：两人都中等刑期。',
    options: [],
    correctIndex: -1,
    explanation: '答案：当贴现因子（对未来收益的重视程度）足够大（通常大于1/2）时，采用“以牙还牙”可以构成子博弈精炼纳什均衡，双方合作是稳定的。'
  },
  {
    id: 460,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '抛一枚硬币，直到出现反面为止。如果第一次就反面，得1元；连续2次正面才反面，得2元；连续n次正面才反面，得2^(n-1)元。问该游戏的期望收益是多少？你愿意付多少钱玩这个游戏？',
    options: [],
    correctIndex: -1,
    explanation: '答案：期望收益是无穷大（每一项概率1/2^n，奖金2^(n-1)，乘积为1/2，无限项求和发散）。但人们实际上只愿意付很少的钱，因为边际效用递减和极小概率的巨大收益。'
  },
  {
    id: 461,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '爱因斯坦谜题变种：五栋不同颜色的房子排成一排，主人来自不同国家，喝不同饮料。已知：英国人住红房子；绿房子在白房子左边且相邻；咖啡在绿房子里；抽Pall Mall的人养鸟；抽Dunhill的人在黄房子。如果Dunhill抽的是黄房子，并且已知黄房子在中间，问谁喝牛奶？',
    options: ['英国人', '挪威人', '丹麦人', '无法确定'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 462,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '阿基里斯速度10m/s，乌龟速度1m/s，乌龟先跑100m。阿基里斯永远追不上乌龟的逻辑（芝诺悖论）错在哪里？\n题目背景：芝诺的推理过程是：1. 阿基里斯速度 10m/s，乌龟速度 1m/s，乌龟先跑 100m。2. 阿基里斯跑完 100m 时，乌龟又向前跑了 10m；3. 阿基里斯跑完这 10m 时，乌龟又向前跑了 1m；4. 阿基里斯跑完这 1m 时，乌龟又向前跑了 0.1m……如此无限循环，得出 “阿基里斯永远追不上乌龟” 的结论。',
    options: [],
    correctIndex: -1,
    explanation: '答案：芝诺悖论的逻辑错误在于，它错误地认为 “无限次分割的过程必然需要无限长的时间”，忽略了收敛无穷级数可以在有限时间内完成。'
  },
  {
    id: 463,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一个形容词如果描述自身，称为“自谓”的，如“中文的”；如果不描述自身，称为“他谓”的，如“英文的”。问“他谓的”这个词是否属于“他谓的”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：这是罗素悖论的变体。如果“他谓的”是他谓的，则它描述自身，矛盾（因为描述自身应是自谓）。如果“他谓的”是自谓的，则它不描述自身，矛盾。因此无解。'
  },
  {
    id: 464,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '海盗分金币问题体现了什么推理方法？\n题目背景：有5 个聪明且自私、冷血、守规则的海盗，抢到一批金币，按1 号到 5 号顺序依次提议分配方案。规则：1. 按序号轮流提分配方案；2. 所有海盗投票，半数及以上同意方案通过执行；3. 方案不通过，提议者被扔海里，下一号继续提议；',
    options: ['归纳法', '倒推法', '穷举法', '随机法'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 465,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '五栋不同颜色的房子排成一排，主人来自不同国家，喝不同饮料。已知：英国人住红房子；绿房子在白房子左边且相邻；咖啡在绿房子里；抽Pall Mall的人养鸟；抽Dunhill的人在黄房子。如果Dunhill抽的是黄房子，并且已知黄房子在中间，问谁喝牛奶？',
    options: ['英国人', '挪威人', '丹麦人', '无法确定'],
    correctIndex: 3,
    explanation: '正确答案：D'
  },
  {
    id: 466,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有10个箱子，每个箱子装有10个球，其中9个箱子中的球重10克，1个箱子中的球重9克。只允许用电子秤称一次，找出轻的箱子。采用编号1-10取对应数量球的方法，若称出总重量是544克，请问几号箱是轻的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：6号'
  },
  {
    id: 467,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '甲说：“我的兄弟比我的姐妹多2个。”乙（甲的姐妹）说：“我的兄弟比我的姐妹多4个。”问这个家庭中男孩和女孩各有多少人？',
    options: ['男孩3，女孩2', '男孩4，女孩1', '男孩5，女孩3', '男孩2，女孩4'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 468,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一个班级里，至少有两个人生日相同的概率超过50%，最少需要多少人？（假设一年365天）',
    options: [],
    correctIndex: -1,
    explanation: '答案：23人'
  },
  {
    id: 469,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '轮盘上有37个数字（0-36），押红黑各18个，押中赔率1:1。是否存在一种投注策略，能保证在有限次数内一定赢钱？（不考虑限红）',
    options: [],
    correctIndex: -1,
    explanation: '答案：不存在。因为马丁格尔策略（倍投）在有限本金下最终会破产，且零点的存在导致期望为负，是“赌徒谬误”。除非有无穷资本且无下注上限，否则不可能保证盈利。'
  },
  {
    id: 470,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一块空地上有一头奶牛。农夫A说：“我看到那边有一头奶牛。”农夫B说：“我看到那头奶牛是黑色的。”过了一会儿，奶牛确实在那边，且是黑的。请问A和B说的命题分别对应的知识论“盖梯尔问题”是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：盖梯尔问题反驳“知识是确证的真信念”。假设农夫A看到的其实是远处一块像奶牛的黑石头，但恰好真正的奶牛藏在石头后面。A相信“有奶牛”为真且被确证，但不是知识。B同样。'
  },
  {
    id: 471,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有4个人要过一座桥，过桥时必须持手电筒，桥上每次最多只能通过2人。4个人过桥速度分别为1分钟、2分钟、5分钟、10分钟。两人一起过桥时，时间按慢者计算。问他们全部过桥最短需要多少分钟？',
    options: ['17', '18', '19', '20'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 472,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '23枚硬币10枚正面朝上，蒙眼分成两堆，怎么让两堆正面朝上数量相同？',
    options: [],
    correctIndex: -1,
    explanation: '答案：分成10和13枚，把10枚那堆全部翻面'
  },
  {
    id: 473,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '数列1, 11, 21, 1211, 111221的下一个数是什么？',
    options: ['112221', '312211', '1112221', '321122'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 474,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在围棋棋盘（19×19）上，纵横各19条线构成361个交叉点。要在棋盘上放置尽可能多的棋子，使得任意3颗棋子都不在一条直线上（任意方向），最多能放几颗？',
    options: [],
    correctIndex: -1,
    explanation: '答案：38 颗'
  },
  {
    id: 475,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一杯酒和一杯水，从酒中舀一勺到水里搅匀，再从混合液中舀一勺回到酒中。问现在酒中的水多，还是水中的酒多？',
    options: [],
    correctIndex: -1,
    explanation: '答案：一样多'
  },
  {
    id: 476,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有一个5升水壶和一个3升水壶，无限水，如何精确量出4升水？',
    options: [],
    correctIndex: -1,
    explanation: '答案：5升装满，倒入3升（5剩2）；倒掉3升，将2升倒入3升；5升装满，倒入3升（此时3升已有2升，只能倒1升），5升中剩4升。'
  },
  {
    id: 477,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '100个囚犯找自己编号纸条的最优策略叫什么？\n题目背景：这是经典的100 囚犯问题（The 100 Prisoners Problem），原题设定如下：1. 100 个囚犯，每人有一个从 1 到 100 的唯一编号。2. 房间里有 100 个盒子，每个盒子里放着一张纸条，上面写着 1-100 的随机编号，每个盒子的编号也从 1 到 100。3. 囚犯们依次进入房间，每人可以打开最多 50 个盒子，寻找写有自己编号的纸条。4. 如果所有囚犯都找到了自己的编号，所有人都被释放；只要有一个人没找到，所有人都被处死。5. 囚犯在进入房间前可以商量策略，但进入房间后不能交流，也不能改动盒子里的纸条。',
    options: [],
    correctIndex: -1,
    explanation: '答案：循环查找策略（环策略）'
  },
  {
    id: 478,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: 'A、B、C决斗，A枪法最差（命中1/3），B命中2/3，C百发百中。三人按A、B、C顺序轮流开枪，每人可以选择任意目标或放空枪。问A的最佳策略是什么？',
    options: [],
    correctIndex: -1,
    explanation: '答案：A的最佳策略是第一枪放空枪。因为B和C都会优先攻击威胁最大的C和B，A放空枪降低了自己的威胁，提高了存活率。'
  },
  {
    id: 479,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在量子力学中，一个粒子的位置和动量不能同时被精确测量。请问这是否违反了经典逻辑中的“排中律”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：没有违反排中律。排中律是“P或非P”为真。海森堡不确定关系只说明“P且Q”为假（位置确定且动量确定），但“位置确定或位置不确定”依然为真，未违反经典逻辑，只是揭示了非对易算符的性质。'
  },
  {
    id: 480,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在一个完全图K6中，用红蓝两色给边染色，证明必然存在一个单色三角形。',
    options: [],
    correctIndex: -1,
    explanation: '答案：任取一点v，它有5条边，由鸽巢原理，至少3条边同色（比如红）。这3条边对应的另外3个顶点之间，若有任一条红边，则与v构成红三角形；若全为蓝，则这3个顶点构成蓝三角形。'
  },
  {
    id: 481,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '100个囚犯100个抽屉，每人最多开50个，找自己编号纸条，有策略让存活率超30%吗？',
    options: ['没有，最多50%', '有，约31%概率', '有，约50%概率', '有，100%成功'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 482,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '是否存在一个包含了自然数算术的形式系统，它是完备的且自洽的？',
    options: [],
    correctIndex: -1,
    explanation: '答案：不存在。哥德尔第一不完备定理证明，任何包含皮亚诺算术且自洽的形式系统，都至少存在一个在该系统中无法证明也无法证伪的命题。'
  },
  {
    id: 483,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一张彩票的期望值是正数，但你把彩票送给朋友，朋友送你一半钱，你和朋友谁的期望收益更高？',
    options: [],
    correctIndex: -1,
    explanation: '答案：朋友的期望收益更高。因为朋友没有花钱，他得到一半的期望值是正数；你得到了朋友的一半钱，但失去了彩票的全部可能收益，总期望比原来低。'
  },
  {
    id: 484,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一列火车匀速行驶，车头灯和车尾灯在地面参考系中同时发出闪光，在地面站台上的人看来，这两束光是否同时到达站台中点？在火车上的人看来呢？',
    options: [],
    correctIndex: -1,
    explanation: '答案：根据狭义相对论，地面上的人看到同时到达（因为光速恒定，且中点距离相等）；火车上的人看到车尾灯的光先到达中点（因为中点向车尾灯方向运动，先迎向光）。'
  },
  {
    id: 485,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有n个人分一个蛋糕，每个人都想得到尽可能多的份额，并且每个人都不希望自己的份额比别人少。设计一种切蛋糕的方法，保证每个人都认为自己的份额是最大的（至少不劣于别人）。',
    options: [],
    correctIndex: -1,
    explanation: '答案：经典“我切你选”法推广：让第一个人切出他认为的1/n，第二个人可以调整（切掉他认为多的部分），最后按顺序挑选。'
  },
  {
    id: 486,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '5对夫妇10人圆桌就坐，5对夫妇恰好都相邻的概率约为多少？',
    options: [],
    correctIndex: -1,
    explanation: '答案：约0.21%'
  },
  {
    id: 487,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '是否存在一个程序H，它能判断任意程序P在输入I上是否会停机？',
    options: [],
    correctIndex: -1,
    explanation: '答案：不存在。图灵证明了停机问题是不可判定的。反证法：假设H存在，构造程序G，若H(G,G)停机，则G不停机；若H(G,G)不停机，则G停机，矛盾。'
  },
  {
    id: 488,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '三门问题（变式）：如果主持人打开空门时，他完全随机地选了一扇门，碰巧打开了空门，此时换门的中奖概率是多少？',
    options: [],
    correctIndex: -1,
    explanation: '答案：1/2。因为主持人随机开门的行为给你的信息发生了变化，你最初选择的门（1/3）和另一扇未选择的门（1/3）现在变得对称，概率各为1/2。'
  },
  {
    id: 489,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '8×8棋盘去掉对角两个格子，剩下62格能用31张2×1多米诺骨牌完全覆盖吗？',
    options: ['能', '不能', '不一定', '要看怎么去'],
    correctIndex: 1,
    explanation: '正确答案：B'
  },
  {
    id: 490,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有若干根绳子，每根烧完需要1小时，但燃烧速度不均匀。如何用这些绳子测量出45分钟？（只给两根绳子）',
    options: [],
    correctIndex: -1,
    explanation: '答案：一根点两头，另一根点一头。第一根烧完是30分钟，此时第二根烧了30分钟，剩余还能烧30分钟，此时点燃第二根的另一头，剩余15分钟烧完，总共45分钟。'
  },
  {
    id: 491,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: 'ABCD四人过桥，时间1、2、5、10分钟，两人同行以慢的为准，只有一个手电，最少需要几分钟？',
    options: ['17分钟', '18分钟', '19分钟', '20分钟'],
    correctIndex: 0,
    explanation: '正确答案：A'
  },
  {
    id: 492,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '在一个无限大的二维网格中，只允许向右或向上走。从(0,0)走到(m,n)，有多少条不同的最短路径？',
    options: [],
    correctIndex: -1,
    explanation: '答案：C(m+n, m) 或 C(m+n, n)'
  },
  {
    id: 493,
    type: QuestionType.SINGLE_CHOICE,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '23个人中至少两人生日相同的概率是多少？',
    options: ['约6%', '约23%', '约50.7%', '约90%'],
    correctIndex: 2,
    explanation: '正确答案：C'
  },
  {
    id: 494,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '两条路，一条通往天堂，一条通往地狱。路口站着两个人，一个只说真话，一个只说假话。你只能问一个问题，如何确定通往天堂的路？',
    options: [],
    correctIndex: -1,
    explanation: '答案：问其中任意一个人：“如果我问另一个人‘哪条路通往天堂？’，他会指哪条路？”然后走相反的那条路。'
  },
  {
    id: 495,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '5个哲学家围坐，每人面前一盘面，两两之间一根筷子。要吃东西必须拿起左右两根筷子。如何设计协议防止死锁？',
    options: [],
    correctIndex: -1,
    explanation: '答案：1. 限制最多4个人同时拿筷子；2. 要求哲学家必须同时拿起两根筷子（原子操作）；3. 规定单号先拿左，双号先拿右（破坏循环等待）。'
  },
  {
    id: 496,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '如果虫洞连接了时空中的两个点，一个人从A口进入，从B口出来。请问这能否允许“回到过去”并杀死自己的祖父？物理学家通常用什么原理排除这种可能？',
    options: [],
    correctIndex: -1,
    explanation: '答案：霍金提出了“时序保护猜想”，认为量子引力效应会阻止宏观物体通过虫洞回到过去，防止因果律悖论。'
  },
  {
    id: 497,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '一条绳子绕地球赤道一周（约40000km），将绳子加长10米，使得绳子离开地面形成一个均匀的圆环。请问绳子离地面的高度大约是多少？',
    options: [],
    correctIndex: -1,
    explanation: '答案：约1.59米（计算：10 / (2π) ≈ 1.59米），与地球半径无关，很反直觉。'
  },
  {
    id: 498,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '甲、乙、丙三人参加选美，观众投票，每人投一票（不可弃权）。已知观众中有2/3的人认为甲比乙美，有2/3的人认为乙比丙美。能否推出至少有1/3的人认为甲比丙美？这是否涉及“偏好传递性”？',
    options: [],
    correctIndex: -1,
    explanation: '答案：不能推出。因为社会选择中，多数投票可能导致“孔多塞悖论”（循环偏好），甲>乙、乙>丙，但丙>甲可能被大多数人支持。传递性在群体投票中不成立。'
  },
  {
    id: 499,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '有一个圆桌子，甲乙两人轮流往桌子上放相同大小的硬币，硬币不能重叠，直到放不下为止。最后放不下硬币的人输。问先手是否有必胜策略？',
    options: [],
    correctIndex: -1,
    explanation: '答案：有。先手先在桌子正中心放一枚硬币，然后无论后手放在哪里，先手都放在关于中心对称的位置。因为圆关于中心对称，只要后手有地方放，对称位置就有地方放。先手必胜。'
  },
  {
    id: 500,
    type: QuestionType.SHORT_ANSWER,
    difficulty: Difficulty.CHALLENGE,
    topic: Topic.REASONING,
    title: '假设上帝给你一个黑盒，可以瞬间判断任意程序是否停机。你能用这个黑盒判断一个程序是否会输出“Hello World”吗？请说明原因。',
    options: [],
    correctIndex: -1,
    explanation: '答案：不能。即使有停机黑盒，判断程序输出特定字符串仍是不可判定的。因为可以将输出问题规约到停机问题：构造程序，它先运行目标程序，若输出特定字符串则停机，否则不停机，但这依赖于模拟，本质仍是不可判定。'
  },
];

// 导出兼容命名，供其他页面直接引用
export const questionBank: Question[] = allQuestions;

// 获取全部题目
export function getAllQuestions(): Question[] {
  return allQuestions;
}

// 按主题和难度筛选题目
export function getQuestionsByTopicAndDifficulty(
  topic: Topic,
  difficulty: Difficulty | 'mixed'
): Question[] {
  let result = allQuestions;
  if (topic !== undefined) {
    result = result.filter(q => q.topic === topic);
  }
  if (difficulty !== 'mixed') {
    result = result.filter(q => q.difficulty === difficulty);
  }
  return result;
}

// 按主题获取混合难度题目（随机乱序）
export function getMixedQuestionsByTopic(topic: Topic): Question[] {
  const result = allQuestions.filter(q => q.topic === topic);
  return shuffleArray(result);
}

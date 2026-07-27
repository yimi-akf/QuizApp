import common from '@ohos.app.ability.common';
import { FavoriteStorage, FavoriteRecord, FavoriteGroup } from '../data/FavoriteStorage';
import { questionBank } from '../data/QuestionBank';
import { ThemeManager } from '../data/ThemeManager';
import { AppTheme, THEMES } from '../model/AppTheme';
import { Question } from '../model/Question';
import { QuizPageParams } from './QuizPage';
import { EmptyState } from '../components/EmptyState';
import { topicShortLabel, difficultyLabel } from '../utils/FormatUtil';

class FavoriteItemData {
  public record: FavoriteRecord;
  public question: Question;

  constructor(record: FavoriteRecord, question: Question) {
    this.record = record;
    this.question = question;
  }
}

// 收藏标签内容
@Component
export struct FavoriteTab {
  @Consume('pageStack') pageStack: NavPathStack
  @StorageLink('quizThemeIndex') @Watch('onThemeIndexChange') themeIndex: number = 0;
  @State theme: AppTheme = THEMES[0];
  @State favorites: FavoriteRecord[] = [];
  @State favoriteItems: FavoriteItemData[] = [];
  @State groups: FavoriteGroup[] = [];
  @State selectedGroupId: number = -1;
  @State showCreateGroupDialog: boolean = false;
  @State showGroupMenuDialog: boolean = false;
  @State menuGroupId: number = 0;
  @State showRenameDialog: boolean = false;
  @State showDeleteConfirmDialog: boolean = false;
  @State showMoveGroupDialog: boolean = false;
  @State moveQuestionId: number = 0;
  @State newGroupName: string = '';
  @State renameGroupName: string = '';
  @State headerOpacity: number = 0;
  @State contentOpacity: number = 0;
  @State contentOffset: number = 40;
  @StorageLink('favoriteTabShowTrigger') @Watch('onFavoriteTabShow') favoriteTabShowTrigger: number = 0;

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ThemeManager.syncToAppStorage(context);
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.loadData(context);
    this.playEntranceAnimation();
  }

  onPageShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.loadData(context);
  }

  onThemeIndexChange() {
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
  }

  onFavoriteTabShow() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    this.theme = THEMES[this.themeIndex] ?? THEMES[0];
    this.loadData(context);
  }

  playEntranceAnimation() {
    this.headerOpacity = 1;
    this.contentOpacity = 1;
    this.contentOffset = 0;
  }

  loadData(context: common.UIAbilityContext) {
    this.favorites = FavoriteStorage.loadRecords(context);
    this.groups = FavoriteStorage.loadGroups(context);
    this.refreshFilteredItems();
  }

  refreshFilteredItems() {
    const filtered = this.selectedGroupId === -1
      ? this.favorites
      : this.favorites.filter((r: FavoriteRecord) => r.groupId === this.selectedGroupId);
    const items: FavoriteItemData[] = [];
    filtered.forEach((record: FavoriteRecord) => {
      const q = this.findQuestion(record.questionId);
      if (q !== undefined) {
        items.push(new FavoriteItemData(record, q));
      }
    });
    this.favoriteItems = items;
  }

  selectGroup(groupId: number) {
    this.selectedGroupId = groupId;
    this.refreshFilteredItems();
  }

  findQuestion(questionId: number): Question | undefined {
    return questionBank.find(q => q.id === questionId);
  }

  removeFavorite(questionId: number) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    FavoriteStorage.removeFavorite(context, questionId);
    this.loadData(context);
  }

  startFavoriteQuiz() {
    if (this.favoriteItems.length === 0) {
      return;
    }
    const ids: number[] = [];
    this.favoriteItems.forEach((item: FavoriteItemData) => {
      ids.push(item.record.questionId);
    });
    const first = this.findQuestion(ids[0]);
    if (!first) {
      return;
    }
    this.pageStack.pushPath({
      name: 'Quiz',
      param: {
        topic: first.topic,
        difficulty: first.difficulty,
        questionIds: ids,
        mode: 'normal'
      } as QuizPageParams
    });
  }

  openGroupMenu(groupId: number) {
    this.menuGroupId = groupId;
    this.showGroupMenuDialog = true;
  }

  openCreateGroupDialog() {
    this.newGroupName = '';
    this.showCreateGroupDialog = true;
  }

  confirmCreateGroup() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const trimmed = this.newGroupName.trim();
    if (!trimmed) {
      return;
    }
    FavoriteStorage.createGroup(context, trimmed);
    this.groups = FavoriteStorage.loadGroups(context);
    this.newGroupName = '';
    this.showCreateGroupDialog = false;
  }

  openRenameDialog() {
    const group = this.groups.find((g: FavoriteGroup) => g.id === this.menuGroupId);
    this.renameGroupName = group ? group.name : '';
    this.showGroupMenuDialog = false;
    this.showRenameDialog = true;
  }

  confirmRenameGroup() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const trimmed = this.renameGroupName.trim();
    if (!trimmed) {
      return;
    }
    FavoriteStorage.renameGroup(context, this.menuGroupId, trimmed);
    this.groups = FavoriteStorage.loadGroups(context);
    this.renameGroupName = '';
    this.showRenameDialog = false;
  }

  openDeleteConfirmDialog() {
    this.showGroupMenuDialog = false;
    this.showDeleteConfirmDialog = true;
  }

  confirmDeleteGroup() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    FavoriteStorage.deleteGroup(context, this.menuGroupId);
    this.groups = FavoriteStorage.loadGroups(context);
    this.favorites = FavoriteStorage.loadRecords(context);
    if (this.selectedGroupId === this.menuGroupId) {
      this.selectedGroupId = -1;
    }
    this.refreshFilteredItems();
    this.showDeleteConfirmDialog = false;
  }

  openMoveGroupDialog(questionId: number) {
    this.moveQuestionId = questionId;
    this.showMoveGroupDialog = true;
  }

  moveFavoriteToGroup(groupId: number) {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    FavoriteStorage.moveToGroup(context, this.moveQuestionId, groupId);
    this.favorites = FavoriteStorage.loadRecords(context);
    this.refreshFilteredItems();
    this.showMoveGroupDialog = false;
  }

  @Builder
  FavoriteItem(item: FavoriteItemData) {
    Row() {
      Column() {
        Text(item.question.title)
          .fontSize(15)
          .fontColor(this.theme.textPrimary)
          .fontWeight(FontWeight.Medium)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(`${topicShortLabel(item.question.topic)} · ${difficultyLabel(item.question.difficulty)}`)
          .fontSize(12)
          .fontColor(this.theme.textSecondary)
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('★')
        .fontSize(22)
        .fontColor(this.theme.warning)
        .width(44)
        .height(44)
        .textAlign(TextAlign.Center)
        .padding({ top: 9 })
        .stateStyles({
          pressed: { .scale({ x: 0.85, y: 0.85 }) },
          normal: { .scale({ x: 1, y: 1 }) }
        })
        .onClick(() => this.removeFavorite(item.record.questionId))
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.theme.card)
    .borderRadius(16)
    .shadow({
      radius: 8,
      color: 'rgba(0,0,0,0.06)',
      offsetX: 0,
      offsetY: 4
    })
    .stateStyles({
      pressed: { .scale({ x: 0.98, y: 0.98 }) },
      normal: { .scale({ x: 1, y: 1 }) }
    })
    .onClick(() => {
      this.pageStack.pushPath({
        name: 'Quiz',
        param: {
          topic: item.question.topic,
          difficulty: item.question.difficulty,
          questionIds: [item.question.id],
          mode: 'normal'
        } as QuizPageParams
      });
    })
    .gesture(
      LongPressGesture()
        .onAction(() => {
          this.openMoveGroupDialog(item.record.questionId);
        })
    )
  }

  @Builder
  CreateGroupDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.theme.overlayScrim)
        .onClick(() => { })

      Column({ space: 16 }) {
        Text('新建分组')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)

        TextInput({ placeholder: '请输入分组名称', text: this.newGroupName })
          .width('100%')
          .height(44)
          .fontSize(15)
          .fontColor(this.theme.textPrimary)
          .backgroundColor(this.theme.background)
          .borderRadius(12)
          .padding({ left: 12, right: 12 })
          .onChange((value: string) => {
            this.newGroupName = value;
          })

        Row({ space: 12 }) {
          Button('取消')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textPrimary)
            .backgroundColor(this.theme.background)
            .borderRadius(22)
            .onClick(() => {
              this.newGroupName = '';
              this.showCreateGroupDialog = false;
            })

          Button('确认')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.primary)
            .borderRadius(22)
            .onClick(() => this.confirmCreateGroup())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  @Builder
  RenameDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.theme.overlayScrim)
        .onClick(() => { })

      Column({ space: 16 }) {
        Text('重命名分组')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)

        TextInput({ placeholder: '请输入新的分组名称', text: this.renameGroupName })
          .width('100%')
          .height(44)
          .fontSize(15)
          .fontColor(this.theme.textPrimary)
          .backgroundColor(this.theme.background)
          .borderRadius(12)
          .padding({ left: 12, right: 12 })
          .onChange((value: string) => {
            this.renameGroupName = value;
          })

        Row({ space: 12 }) {
          Button('取消')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textPrimary)
            .backgroundColor(this.theme.background)
            .borderRadius(22)
            .onClick(() => {
              this.renameGroupName = '';
              this.showRenameDialog = false;
            })

          Button('确认')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.primary)
            .borderRadius(22)
            .onClick(() => this.confirmRenameGroup())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  @Builder
  DeleteConfirmDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.theme.overlayScrim)
        .onClick(() => { })

      Column({ space: 16 }) {
        Text('删除分组')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)

        Text('确定要删除此分组吗？分组内的收藏将移回默认分组。')
          .fontSize(14)
          .fontColor(this.theme.textPrimary)
          .textAlign(TextAlign.Center)
          .width('100%')

        Row({ space: 12 }) {
          Button('取消')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textPrimary)
            .backgroundColor(this.theme.background)
            .borderRadius(22)
            .onClick(() => {
              this.showDeleteConfirmDialog = false;
            })

          Button('确认删除')
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .fontColor(this.theme.textOnPrimary)
            .backgroundColor(this.theme.error)
            .borderRadius(22)
            .onClick(() => this.confirmDeleteGroup())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  @Builder
  GroupMenuDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.theme.overlayScrim)
        .onClick(() => {
          this.showGroupMenuDialog = false;
        })

      Column({ space: 12 }) {
        Text('分组操作')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)

        Button('重命名')
          .width('100%')
          .height(44)
          .fontSize(15)
          .fontColor(this.theme.textPrimary)
          .backgroundColor(this.theme.background)
          .borderRadius(22)
          .onClick(() => this.openRenameDialog())

        Button('删除分组')
          .width('100%')
          .height(44)
          .fontSize(15)
          .fontColor(this.theme.error)
          .backgroundColor(this.theme.background)
          .borderRadius(22)
          .onClick(() => this.openDeleteConfirmDialog())

        Button('取消')
          .width('100%')
          .height(44)
          .fontSize(15)
          .fontColor(this.theme.textSecondary)
          .backgroundColor(this.theme.background)
          .borderRadius(22)
          .onClick(() => {
            this.showGroupMenuDialog = false;
          })
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  @Builder
  MoveGroupDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.theme.overlayScrim)
        .onClick(() => {
          this.showMoveGroupDialog = false;
        })

      Column({ space: 12 }) {
        Text('移动到分组')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.theme.primary)

        Scroll() {
          Column({ space: 8 }) {
            Text('默认')
              .fontSize(15)
              .fontColor(this.theme.textPrimary)
              .width('100%')
              .height(44)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.theme.background)
              .borderRadius(12)
              .stateStyles({
                pressed: { .scale({ x: 0.97, y: 0.97 }) },
                normal: { .scale({ x: 1, y: 1 }) }
              })
              .onClick(() => this.moveFavoriteToGroup(0))

            ForEach(this.groups, (group: FavoriteGroup) => {
              Text(group.name)
                .fontSize(15)
                .fontColor(this.theme.textPrimary)
                .width('100%')
                .height(44)
                .textAlign(TextAlign.Center)
                .backgroundColor(this.theme.background)
                .borderRadius(12)
                .stateStyles({
                  pressed: { .scale({ x: 0.97, y: 0.97 }) },
                  normal: { .scale({ x: 1, y: 1 }) }
                })
                .onClick(() => this.moveFavoriteToGroup(group.id))
            }, (group: FavoriteGroup) => String(group.id))
          }
          .width('100%')
        }
        .width('100%')
        .constraintSize({ maxHeight: 300 })
        .scrollBar(BarState.Off)

        Button('取消')
          .width('100%')
          .height(44)
          .fontSize(15)
          .fontColor(this.theme.textSecondary)
          .backgroundColor(this.theme.background)
          .borderRadius(22)
          .onClick(() => {
            this.showMoveGroupDialog = false;
          })
      }
      .width('80%')
      .padding(24)
      .backgroundColor(this.theme.card)
      .borderRadius(20)
      .shadow({
        radius: 16,
        color: 'rgba(0,0,0,0.2)',
        offsetX: 0,
        offsetY: 8
      })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
  }

  build() {
    Stack() {
      Column() {
        // 顶部标题区
        Column() {
          Text('我的收藏')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.theme.textOnPrimary)
            .textShadow({
              radius: 10,
              color: 'rgba(0,0,0,0.15)',
              offsetX: 0,
              offsetY: 4
            })
            .margin({ bottom: 8 })

          Text(`共 ${this.favorites.length} 道收藏题目`)
            .fontSize(15)
            .fontColor(this.theme.textOnPrimaryMuted)
        }
        .width('100%')
        .height(220)
        .justifyContent(FlexAlign.Center)
        .opacity(this.headerOpacity)
        .animation({ duration: 600, curve: Curve.EaseOut })
        .linearGradient({
          angle: 135,
          colors: [[this.theme.primaryGradientStart, 0.0], [this.theme.primaryGradientEnd, 1.0]]
        })
        .borderRadius({ bottomLeft: 28, bottomRight: 28 })
        .shadow({
          radius: 12,
          color: 'rgba(0,0,0,0.12)',
          offsetX: 0,
          offsetY: 6
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

        if (this.favorites.length === 0) {
          EmptyState({
            icon: '⭐',
            title: '还没有收藏题目',
            subtitle: '在答题时长按题目或点击收藏按钮，\n即可加入收藏',
            theme: this.theme
          })
        } else {
          Column({ space: 12 }) {
            Button(this.selectedGroupId === -1 ? '开始练习全部收藏' : '开始练习当前分组')
              .width('100%')
              .height(48)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.theme.textOnPrimary)
              .backgroundColor(this.theme.primary)
              .borderRadius(24)
              .stateStyles({
                pressed: { .scale({ x: 0.97, y: 0.97 }) },
                normal: { .scale({ x: 1, y: 1 }) }
              })
              .onClick(() => this.startFavoriteQuiz())

            // 分组选择栏
            Scroll() {
              Row({ space: 8 }) {
                Text('全部')
                  .fontSize(14)
                  .fontWeight(this.selectedGroupId === -1 ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.selectedGroupId === -1 ? this.theme.textOnPrimary : this.theme.textSecondary)
                  .backgroundColor(this.selectedGroupId === -1 ? this.theme.primary : this.theme.card)
                  .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                  .borderRadius(16)
                  .stateStyles({
                    pressed: { .scale({ x: 0.95, y: 0.95 }) },
                    normal: { .scale({ x: 1, y: 1 }) }
                  })
                  .onClick(() => this.selectGroup(-1))

                Text('默认')
                  .fontSize(14)
                  .fontWeight(this.selectedGroupId === 0 ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.selectedGroupId === 0 ? this.theme.textOnPrimary : this.theme.textSecondary)
                  .backgroundColor(this.selectedGroupId === 0 ? this.theme.primary : this.theme.card)
                  .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                  .borderRadius(16)
                  .stateStyles({
                    pressed: { .scale({ x: 0.95, y: 0.95 }) },
                    normal: { .scale({ x: 1, y: 1 }) }
                  })
                  .onClick(() => this.selectGroup(0))

                ForEach(this.groups, (group: FavoriteGroup) => {
                  Text(group.name)
                    .fontSize(14)
                    .fontWeight(this.selectedGroupId === group.id ? FontWeight.Bold : FontWeight.Normal)
                    .fontColor(this.selectedGroupId === group.id ? this.theme.textOnPrimary : this.theme.textSecondary)
                    .backgroundColor(this.selectedGroupId === group.id ? this.theme.primary : this.theme.card)
                    .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                    .borderRadius(16)
                    .stateStyles({
                      pressed: { .scale({ x: 0.95, y: 0.95 }) },
                      normal: { .scale({ x: 1, y: 1 }) }
                    })
                    .onClick(() => this.selectGroup(group.id))
                    .gesture(
                      LongPressGesture()
                        .onAction(() => this.openGroupMenu(group.id))
                    )
                }, (group: FavoriteGroup) => String(group.id))

                Text('+')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.theme.primary)
                  .backgroundColor(this.theme.card)
                  .width(36)
                  .height(36)
                  .borderRadius(18)
                  .textAlign(TextAlign.Center)
                  .stateStyles({
                    pressed: { .scale({ x: 0.95, y: 0.95 }) },
                    normal: { .scale({ x: 1, y: 1 }) }
                  })
                  .onClick(() => this.openCreateGroupDialog())
              }
              .padding({ bottom: 4 })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .width('100%')

            Scroll() {
              Column({ space: 12 }) {
                ForEach(this.favoriteItems, (item: FavoriteItemData) => {
                  this.FavoriteItem(item)
                }, (item: FavoriteItemData) => String(item.record.questionId))
              }
              .width('100%')
              .padding({ bottom: 20 })
            }
            .layoutWeight(1)
            .scrollBar(BarState.Off)
          }
          .width('100%')
          .layoutWeight(1)
          .padding({ left: 20, right: 20, top: 20, bottom: 20 })
          .backgroundColor(this.theme.background)
          .opacity(this.contentOpacity)
          .translate({ y: this.contentOffset })
          .animation({ duration: 600, curve: Curve.EaseOut, delay: 150 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.theme.background)

      // 创建分组对话框
      if (this.showCreateGroupDialog) {
        this.CreateGroupDialog()
      }

      // 重命名对话框
      if (this.showRenameDialog) {
        this.RenameDialog()
      }

      // 删除确认对话框
      if (this.showDeleteConfirmDialog) {
        this.DeleteConfirmDialog()
      }

      // 分组操作菜单
      if (this.showGroupMenuDialog) {
        this.GroupMenuDialog()
      }

      // 移动分组对话框
      if (this.showMoveGroupDialog) {
        this.MoveGroupDialog()
      }
    }
  }
}

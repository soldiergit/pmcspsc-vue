<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
      <el-row>
        <el-col :span="12">
          <el-form-item label="立项名称" prop="itemInfoId">
            <template>
              <el-select v-model="dataForm.itemInfoId" placeholder="请选择赛制">
                <el-option
                  v-for="item in itemInfoList"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value">
                </el-option>
              </el-select>
            </template>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="团队编号" prop="teamCode">
            <el-input v-model="dataForm.teamCode" placeholder="团队编号"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="报名时间" prop="signUpTime">
            <div class="block">
              <el-date-picker
                v-model="dataForm.signUpTime"
                align="right"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="报名时间">
              </el-date-picker>
            </div>
          </el-form-item>
        </el-col>
        <!--<el-col :span="12">-->
          <!--<el-form-item label="立项id" prop="itemInfoId">-->
            <!--<el-input v-model="dataForm.itemInfoId" placeholder="立项id"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <el-col :span="12">
          <el-form-item label="项目编号" prop="itemInfoCode">
            <el-input v-model="dataForm.itemInfoCode" placeholder="项目编号"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="24">
          <el-form-item label="赛题" prop="matchTitle">
            <el-input v-model="dataForm.matchTitle" placeholder="赛题"></el-input>
          </el-form-item>
        </el-col>
        <!--<el-col :span="12">-->
          <!--<el-form-item label="获奖级别：国家级：区级" prop="awardGrade">-->
            <!--<el-input v-model="dataForm.awardGrade" placeholder="获奖级别：国家级：区级"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <!--<el-col :span="12">-->
          <!--<el-form-item label="获奖" prop="awardInfo">-->
            <!--<el-input v-model="dataForm.awardInfo" placeholder="获奖"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <!--<el-col :span="12">-->
          <!--<el-form-item label="删除标识" prop="teamInfoIsDel">-->
            <!--<el-input v-model="dataForm.teamInfoIsDel" placeholder="删除标识"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
      </el-row>
      <!--成员列表 start-->
      <el-row>
        <el-alert
          title="参赛团队成员列表"
          type="success"
          :closable="false">
        </el-alert>
        <el-form-item prop="personList">
          <el-col :span="24">
            <el-table
              :data="personList"
              border
              style="width: 100%;">
              <!--<el-table-column-->
              <!--prop="personInfoId"-->
              <!--header-align="center"-->
              <!--align="center"-->
              <!--label="id">-->
              <!--</el-table-column>-->
              <!--<el-table-column-->
              <!--prop="personTeamInfoId"-->
              <!--header-align="center"-->
              <!--align="center"-->
              <!--label="团队id">-->
              <!--</el-table-column>-->
              <el-table-column
                prop="personCode"
                header-align="center"
                align="center"
                label="学号">
              </el-table-column>
              <el-table-column
                prop="personName"
                header-align="center"
                align="center"
                label="姓名">
              </el-table-column>
              <el-table-column
                prop="personInstitute"
                header-align="center"
                align="center"
                label="学院">
              </el-table-column>
              <el-table-column
                prop="personClass"
                header-align="center"
                align="center"
                label="班级">
              </el-table-column>
              <el-table-column
                prop="personGrade"
                header-align="center"
                align="center"
                label="年级">
              </el-table-column>
              <el-table-column
                prop="personMajor"
                header-align="center"
                align="center"
                label="专业">
              </el-table-column>
              <el-table-column
                prop="personEmail"
                header-align="center"
                align="center"
                label="邮箱">
              </el-table-column>
              <el-table-column
                prop="personPhone"
                header-align="center"
                align="center"
                label="电话">
              </el-table-column>
              <!--<el-table-column-->
              <!--prop="personInfoIsDel"-->
              <!--header-align="center"-->
              <!--align="center"-->
              <!--label="删除标识">-->
              <!--</el-table-column>-->
              <el-table-column
                fixed="right"
                header-align="center"
                align="center"
                width="150"
                label="操作">
                <template slot-scope="scope">
                  <el-button type="text" size="small" @click="updatePersonHandle(scope.row, scope.$index)">修改</el-button>
                  <el-button type="text" size="small" @click="deletePersonHandle(scope.$index)">删除</el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-col>
        </el-form-item>
        <el-form-item>
          <el-button type="success" plain @click="addPersonHandle()">添加成员</el-button>
        </el-form-item>
      </el-row>
      <!--成员列表 end-->
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false, personList = []">取消</el-button>
      <el-button type="primary" @click="dataFormSubmit()">确定</el-button>
    </span>
    <!-- 弹窗, 新增 / 修改 -->
    <add-or-update-person v-if="addOrUpdatePersonVisible" ref="addOrUpdatePerson" @refreshDataList="refreshPerson"></add-or-update-person>
  </el-dialog>
</template>

<script>
  import AddOrUpdatePerson from './pmteampersoninfo-add-or-update'
  export default {
    data () {
      var validatePerson = (rule, value, callback) => {
        if (this.fileList.length === 0) {
          callback(new Error('团队成员不能为空'))
          // } else {
          //   let notNull = false
          //   for (let index = 0; index < this.attachLists.length; index++) {
          //     if (this.attachLists[index].isDel === 0) {
          //       notNull = true
          //     }
          //   }
          //   if (notNull) {
          //     callback()
          //   } else {
          //     callback(new Error('团队成员不能为空'))
          //   }
        }
      }
      return {
        visible: false,
        dataForm: {
          teamId: 0,
          teamCode: '',
          itemInfoId: '',
          itemInfoCode: '',
          matchTitle: '',
          signUpTime: '',
          awardGrade: '',
          awardInfo: '',
          teamInfoIsDel: 0
        },
        dataRule: {
          teamCode: [
            { required: true, message: '团队编号不能为空', trigger: 'blur' }
          ],
          itemInfoId: [
            { required: true, message: '立项项目不能为空', trigger: 'blur' }
          ],
          itemInfoCode: [
            { required: true, message: '项目编号不能为空', trigger: 'blur' }
          ],
          matchTitle: [
            { required: true, message: '赛题不能为空', trigger: 'blur' }
          ],
          signUpTime: [
            { required: true, message: '报名时间不能为空', trigger: 'blur' }
          ],
          awardGrade: [
            { required: true, message: '获奖级别：国家级：区级不能为空', trigger: 'blur' }
          ],
          awardInfo: [
            { required: true, message: '获奖不能为空', trigger: 'blur' }
          ],
          teamInfoIsDel: [
            { required: true, message: '删除标识不能为空', trigger: 'blur' }
          ],
          personList: [
            { validate: validatePerson, trigger: 'blur' }
          ]
        },
        itemInfoList: [],
        addOrUpdatePersonVisible: false,
        personList: []
      }
    },
    components: {
      AddOrUpdatePerson
    },
    methods: {
      init (id) {
        this.dataForm.teamId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          // 请求立项项目数据
          this.$http({
            url: this.$http.adornUrl('/pm/item/list'),
            method: 'get',
            params: this.$http.adornParams({
              'page': 1,
              'limit': 10000,
              'itemInfoStatus': 2,
              'userId': this.$store.state.user.id
            })
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.itemInfoList = []
              data.page.list.forEach(item => {
                this.itemInfoList.push({value: item.itemInfoId, label: item.matchName})
              })
            } else {
              this.$message.error(data.msg)
            }
          })
          if (this.dataForm.teamId) {
            //  团队信息
            this.$http({
              url: this.$http.adornUrl(`/pm/team/info/${this.dataForm.teamId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.teamCode = data.pmTeamInfo.teamCode
                this.dataForm.itemInfoId = data.pmTeamInfo.itemInfoId
                this.dataForm.itemInfoCode = data.pmTeamInfo.itemInfoCode
                this.dataForm.matchTitle = data.pmTeamInfo.matchTitle
                this.dataForm.signUpTime = data.pmTeamInfo.signUpTime
                this.dataForm.awardGrade = data.pmTeamInfo.awardGrade
                this.dataForm.awardInfo = data.pmTeamInfo.awardInfo
                this.dataForm.teamInfoIsDel = data.pmTeamInfo.teamInfoIsDel
                this.personList = data.pmTeamInfo.pmTeamPersonInfoEntities
              }
            })
          }
        })
      },
      // 表单提交
      dataFormSubmit () {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.$http({
              url: this.$http.adornUrl(`/pm/team/${!this.dataForm.teamId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'teamId': this.dataForm.teamId || undefined,
                'userId': this.$store.state.user.id,
                'teamCode': this.dataForm.teamCode,
                'itemInfoId': this.dataForm.itemInfoId,
                'itemInfoCode': this.dataForm.itemInfoCode,
                'matchTitle': this.dataForm.matchTitle,
                'signUpTime': this.dataForm.signUpTime,
                'awardGrade': this.dataForm.awardGrade,
                'awardInfo': this.dataForm.awardInfo,
                'teamInfoIsDel': this.dataForm.teamInfoIsDel,
                'pmTeamPersonInfoEntities': this.personList
              })
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.$message({
                  message: '操作成功',
                  type: 'success',
                  duration: 1500,
                  onClose: () => {
                    this.visible = false
                    //  回调父页面中‘@refreshDataList’定义的刷新方法
                    this.$emit('refreshDataList')
                  }
                })
                this.personList = []
              } else {
                this.$message.error(data.msg)
              }
            })
          }
        })
      },
      // 新增成员
      addPersonHandle () {
        this.addOrUpdatePersonVisible = true
        this.$nextTick(() => {
          this.$refs['addOrUpdatePerson'].init()
        })
      },
      // 修改成员
      updatePersonHandle (row, index) {
        this.addOrUpdatePersonVisible = true
        this.$nextTick(() => {
          this.$refs['addOrUpdatePerson'].init(row, index)
        })
      },
      //  新增 / 修改成员回调
      refreshPerson (data, index) {
        this.addOrUpdatePersonVisible = false
        if (typeof index !== 'undefined' && index != null && index !== '') { // 更新标识
          this.personList.splice(index, 1)
        }
        this.personList.push(data)
      },
      // 删除成员
      deletePersonHandle (index, row) {
        this.personList.splice(index, 1)
      }
    }
  }
</script>

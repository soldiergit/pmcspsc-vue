<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false" width="60%" append-to-body
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="100px">
      <el-row>
        <el-col :span="12">
          <el-form-item label="结题项目" prop="itemInfoId">
            <el-select v-model="dataForm.itemInfoId" filterable placeholder="请选择" @change="getTeamList">
              <el-option
                v-for="item in itemInfoList"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="参赛注册费" prop="pmFundInfoEntity.registerCost">
            <el-input v-model="dataForm.pmFundInfoEntity.registerCost" placeholder="参赛注册费" type="number"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="差旅费" prop="pmFundInfoEntity.travelCost">
            <el-input v-model="dataForm.pmFundInfoEntity.travelCost" placeholder="差旅费" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="培训费" prop="pmFundInfoEntity.trainCost">
            <el-input v-model="dataForm.pmFundInfoEntity.trainCost" placeholder="培训费" type="number"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="评审费" prop="pmFundInfoEntity.reviewCost">
            <el-input v-model="dataForm.pmFundInfoEntity.reviewCost" placeholder="评审费" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="指导费" prop="pmFundInfoEntity.guideCost">
            <el-input v-model="dataForm.pmFundInfoEntity.guideCost" placeholder="指导费" type="number"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="领队费" prop="pmFundInfoEntity.leaderCost">
            <el-input v-model="dataForm.pmFundInfoEntity.leaderCost" placeholder="领队费" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="组织费" prop="pmFundInfoEntity.organizeCost">
            <el-input v-model="dataForm.pmFundInfoEntity.organizeCost" placeholder="组织费" type="number"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="耗材费" prop="pmFundInfoEntity.consumablesCost">
            <el-input v-model="dataForm.pmFundInfoEntity.consumablesCost" placeholder="耗材费" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="奖金" prop="pmFundInfoEntity.awardCost">
            <el-input v-model="dataForm.pmFundInfoEntity.awardCost" placeholder="奖金" type="number"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="其他费用" prop="pmFundInfoEntity.anotherCost">
            <el-input v-model="dataForm.pmFundInfoEntity.anotherCost" placeholder="其他费用" type="number"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <!--成员信息列表 start-->
      <el-row>
        <el-alert
          title="参赛团队列表"
          type="success"
          :closable="false">
        </el-alert>
        <el-col :span="24">
          <el-table
            :data="teamList"
            border
            style="width: 100%;">
            <el-table-column
            label="团队编号"
            prop="teamCode"
            header-align="center"
            align="center">
            </el-table-column>
            <el-table-column
              label="赛题"
              prop="matchTitle"
              header-align="center"
              align="center">
            </el-table-column>
            <el-table-column
              label="报名时间"
              prop="signUpTime"
              header-align="center"
              align="center">
            </el-table-column>
            <el-table-column
              label="获奖信息"
              header-align="center"
              align="center">
              <template slot-scope="scope">
                <div slot="reference" class="name-wrapper">
                  <div v-if="scope.row.awardInfo !==null &&scope.row.awardInfo !==''">
                    <el-tag size="mini">
                      <span v-for="(item, index) in awardInfoList" :key="index" v-if="scope.row.awardInfo === item.value" v-text="item.label"></span>
                    </el-tag>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column
              label="获奖等级"
              header-align="center"
              align="center">
              <template slot-scope="scope">
                <div slot="reference" class="name-wrapper">
                  <div v-if="scope.row.awardGrade !==null &&scope.row.awardGrade !==''">
                    <el-tag size="mini">
                      <span v-for="(item, index) in awardGradeList" :key="index" v-if="scope.row.awardGrade === item.value" v-text="item.label"></span>
                    </el-tag>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column
              fixed="right"
              header-align="center"
              align="center"
              width="150"
              label="操作">
              <template slot-scope="scope">
                <el-button size="mini" plain @click="awardAddOrUpdateHandle(scope.$index, scope.row)">添加奖项</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-col>
      </el-row>
      <!--成员信息列表 end-->
      <el-form-item label="附件">
        <el-upload
          class="upload-demo"
          :action="url"
          :on-remove="handleRemove"
          :on-success="uploadSuccess"
          multiple
          :limit="1"
          :on-exceed="handleExceed"
          :file-list="fileList">
          <el-button size="small" type="primary">点击上传</el-button>
          <div slot="tip" class="el-upload__tip">结题报告书 PDF 扫描件</div>
        </el-upload>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="dataFormSubmit()">确定</el-button>
    </span>
    <award v-if="awardAddOrUpdateVisible" ref="awardAddOrUpdate" @refreshDataList="refAwardList"></award>
  </el-dialog>
</template>

<script>
  import Award from './award-add-or-update'

  export default {
    data () {
      var validateAttach = (rule, value, callback) => {
        if (this.fileList.length === 0) {
          callback(new Error('附件不能为空'))
        // } else {
        //   let notNull = false
        //   for (let index = 0; index < this.fileList.length; index++) {
        //     if (this.fileList[index].attachIsDel === 1) {
        //       notNull = true
        //     }
        //   }
        //   if (notNull) {
        //     callback()
        //   } else {
        //     callback(new Error('附件不能为空'))
        //   }
        }
      }
      return {
        visible: false,
        url: '',
        awardAddOrUpdateVisible: false,
        itemInfoList: [],
        teamList: [],
        fileList: [],
        dataForm: {
          finishInfoId: 0,
          itemInfoId: '',
          finishIsDel: 0,
          userId: '',
          finishInfoStatus: '',
          pmFundInfoEntity: {
            budgetId: 0,
            registerCost: '',
            travelCost: '',
            trainCost: '',
            reviewCost: '',
            guideCost: '',
            leaderCost: '',
            organizeCost: '',
            consumablesCost: '',
            awardCost: '',
            anotherCost: '',
            totalCost: '',
            budgetInfoIsDel: ''
          },
          pmFinishAttachEntity: {
            attachId: '',
            itemInfoId: '',
            attachName: '',
            attachPath: '',
            attachIsDel: ''
          }
        },
        awardGradeList: [
          {value: 1, label: '国家级'},
          {value: 2, label: '区级'},
          {value: 3, label: '校级'}
        ],
        awardInfoList: [
          {value: 1, label: '特等奖'},
          {value: 2, label: '一等奖'},
          {value: 3, label: '二等奖'},
          {value: 4, label: '三等奖'},
          {value: 5, label: '优秀奖'},
          {value: 6, label: '参与奖'},
          {value: 7, label: '无'}
        ],
        dataRule: {
          itemInfoId: [
            { required: true, message: '结题项目不能为空', trigger: 'blur' }
          ],
          pmFundInfoEntity: {
            registerCost: [
              { required: true, message: '参赛注册费不能为空', trigger: 'blur' }
            ],
            travelCost: [
              { required: true, message: '差旅费不能为空', trigger: 'blur' }
            ],
            trainCost: [
              { required: true, message: '培训费不能为空', trigger: 'blur' }
            ],
            reviewCost: [
              { required: true, message: '评审费不能为空', trigger: 'blur' }
            ],
            guideCost: [
              { required: true, message: '指导费不能为空', trigger: 'blur' }
            ],
            leaderCost: [
              { required: true, message: '领队费不能为空', trigger: 'blur' }
            ],
            organizeCost: [
              { required: true, message: '组织费不能为空', trigger: 'blur' }
            ],
            consumablesCost: [
              { required: true, message: '耗材费不能为空', trigger: 'blur' }
            ],
            awardCost: [
              { required: true, message: '奖金不能为空', trigger: 'blur' }
            ],
            anotherCost: [
              { required: true, message: '其他费用不能为空', trigger: 'blur' }
            ]
          },
          pmFinishAttachEntity: [
            { validator: validateAttach, trigger: 'blur' }
          ]
        }
      }
    },
    components: {
      Award
    },
    methods: {
      init (id) {
        this.dataForm.finishInfoId = id || 0
        this.teamList = []
        this.visible = true
        this.url = this.$http.adornUrl(`/pm/finish/attach/upload?token=${this.$cookie.get('token')}`)
        this.$nextTick(() => {
          // 请求结题项目数据
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
              this.$refs['dataForm'].resetFields()
              //  获取结题数据
              if (this.dataForm.finishInfoId) {
                this.$http({
                  url: this.$http.adornUrl(`/pm/finish/info/${this.dataForm.finishInfoId}`),
                  method: 'get',
                  params: this.$http.adornParams()
                }).then(({data}) => {
                  if (data && data.code === 0) {
                    this.dataForm.itemInfoId = data.pmFinishInfo.itemInfoId
                    this.dataForm.finishIsDel = data.pmFinishInfo.finishIsDel
                    this.dataForm.finishInfoStatus = 0
                    this.dataForm.pmFundInfoEntity = data.pmFinishInfo.pmFundInfoEntity
                    this.teamList = data.pmFinishInfo.pmTeamInfoEntities
                    this.dataForm.pmFinishAttachEntity = data.pmFinishInfo.pmFinishAttachEntity
                    if (this.dataForm.pmFinishAttachEntity !== null && this.dataForm.pmFinishAttachEntity.attachPath !== '') {
                      this.fileList = [{name: data.pmFinishInfo.pmFinishAttachEntity.attachName, url: data.pmFinishInfo.pmFinishAttachEntity.attachPath}]
                    }
                  }
                })
              }
            }
          })
        })
      },
      // 表单提交
      dataFormSubmit () {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.$http({
              url: this.$http.adornUrl(`/pm/finish/${!this.dataForm.finishInfoId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'finishInfoId': this.dataForm.finishInfoId || undefined,
                'itemInfoId': this.dataForm.itemInfoId,
                'finishIsDel': this.dataForm.finishIsDel,
                'userId': this.$store.state.user.id,
                'finishInfoStatus': this.dataForm.finishInfoStatus,
                'pmTeamInfoEntities': this.teamList,
                'pmFinishAttachEntity': this.dataForm.pmFinishAttachEntity,
                'pmFundInfoEntity': this.dataForm.pmFundInfoEntity
              })
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.$message({
                  message: '操作成功',
                  type: 'success',
                  duration: 1500,
                  onClose: () => {
                    this.visible = false
                    this.$emit('refreshDataList')
                  }
                })
              } else {
                this.$message.error(data.msg)
              }
            })
          }
        })
      },
      // 获取参赛队伍信息
      getTeamList () {
        this.$http({
          url: this.$http.adornUrl('/pm/team/list'),
          method: 'get',
          params: this.$http.adornParams({
            'page': 1,
            'limit': 10000,
            'itemInfoId': this.dataForm.itemInfoId
          })
        }).then(({data}) => {
          if (data && data.code === 0) {
            this.teamList = data.page.list
          } else {
            this.$message.error(data.msg)
          }
        })
      },
      // 新增 / 修改
      awardAddOrUpdateHandle (index, data) {
        console.log('pmfinishinfo-add-or-update.vue awardAddOrUpdateHandle' + JSON.stringify(data))
        this.awardAddOrUpdateVisible = true
        this.$nextTick(() => {
          this.$refs.awardAddOrUpdate.init(data, index)
        })
      },
      // 刷新参赛队伍信息
      refAwardList (data, index) {
        // 删除位于index的元素，并添加一个新元素data来替代被删除的元素
        this.teamList.splice(index, 1, data)
      },
      // 上传成功
      uploadSuccess (res, file, fileList) {
        this.dataForm.pmFinishAttachEntity = res.pmFinishAttachEntity
      },
      // 移除文件
      handleRemove () {
        this.dataForm.pmFinishAttachEntity.attachIsDel = 1
      },
      // 文件超出个数
      handleExceed () {
      }
    }
  }
</script>

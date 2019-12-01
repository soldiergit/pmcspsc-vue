<template>
  <el-dialog
    :title="!dataForm.id ? '新增项目立项申请表' : '修改项目立项申请表'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-row :gutter="20">
      <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="16rem" style="width: 94%; margin: 0 auto">
        <el-col :span="24">
          <el-form-item label="赛事名称" prop="matchName">
            <el-input v-model="dataForm.matchName" placeholder="赛事名称"></el-input>
          </el-form-item>
        </el-col>
      <el-col :span="24">
          <el-form-item label="组赛单位" prop="matchUnit">
            <el-input v-model="dataForm.matchUnit" placeholder="组赛单位"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="赛制" prop="matchType">
            <el-select v-model="dataForm.matchType" placeholder="请选择">
              <el-option v-for="item in matchTypeList" :key="item.value" :label="item.label" :value="item.value"></el-option>
            </el-select>
          </el-form-item>
      </el-col>
      <!--<el-col :span="24">-->
          <!--<el-form-item label="项目负责人" prop="userId">-->
            <!--<el-input v-model="dataForm.userId" placeholder="项目负责人"></el-input>-->
          <!--</el-form-item>-->
      <!--</el-col>-->
      <el-col :span="24">
          <el-form-item label="竞赛起始日期" prop="matchStartTime">
            <el-date-picker v-model="dataForm.matchStartTime" type="date" value-format="yyyy-MM-dd" placeholder="竞赛起始日期"></el-date-picker>
          </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="竞赛结束日期" prop="matchEndTime">
            <el-date-picker v-model="dataForm.matchEndTime" type="date" value-format="yyyy-MM-dd" placeholder="竞赛结束日期"></el-date-picker>
          </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="专业" prop="matchMajor">
            <el-input v-model="dataForm.matchMajor" placeholder="专业"></el-input>
          </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="竞赛主办单位" prop="hostUnit">
            <el-input v-model="dataForm.hostUnit" placeholder="竞赛主办单位"></el-input>
          </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="竞赛承办单位" prop="undertakeUnit">
            <el-input v-model="dataForm.undertakeUnit" placeholder="竞赛承办单位"></el-input>
          </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="申请立项日期" prop="itemInfoTime">
            <el-date-picker v-model="dataForm.itemInfoTime" type="date" value-format="yyyy-MM-dd" :disabled="true" placeholder="申请立项日期"></el-date-picker>
          </el-form-item>
      </el-col>
      <el-col :span="24">
          <el-form-item label="论证组赛的目的和意义" prop="matchSign">
            <el-input v-model="dataForm.matchSign" placeholder="论证组赛的目的和意义"
                      type="textarea" maxlength="400" :rows="5"></el-input>
          </el-form-item>
      </el-col>
      <!--<el-col :span="24">-->
          <!--<el-form-item label="审核状态" prop="itemInfoStatus">-->
            <!--<el-input v-model="dataForm.itemInfoStatus" placeholder="审核状态"></el-input>-->
          <!--</el-form-item>-->
      <!--</el-col>-->
      <!--<el-col :span="24">-->
          <!--<el-form-item label="是否已经结题" prop="itemInfoFinish">-->
            <!--<el-input v-model="dataForm.itemInfoFinish" placeholder="是否已经结题"></el-input>-->
          <!--</el-form-item>-->
      <!--</el-col>-->
      <!--<el-col :span="24">-->
          <!--<el-form-item label="删除标识" prop="itemInfoIsDel">-->
            <!--<el-input v-model="dataForm.itemInfoIsDel" placeholder="删除标识"></el-input>-->
        <!--</el-form-item>-->
      <!--</el-col>-->
      </el-form>
    </el-row>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="dataFormSubmit()">确定</el-button>
    </span>
  </el-dialog>
</template>

<script>
  export default {
    data () {
      return {
        visible: false,
        matchTypeList: [
          {value: 0, label: '单人赛'},
          {value: 1, label: '团体赛'}
        ],
        dataForm: {
          itemInfoId: 0,
          matchName: '',
          matchUnit: '',
          matchType: '',
          userId: this.$store.state.user.id,
          matchStartTime: '',
          matchEndTime: '',
          matchMajor: '',
          hostUnit: '',
          undertakeUnit: '',
          itemInfoTime: '',
          matchSign: '',
          itemInfoStatus: 0,
          itemInfoFinish: 0,
          itemInfoIsDel: 0
        },
        dataRule: {
          matchName: [
            { required: true, message: '赛事名称不能为空', trigger: 'blur' }
          ],
          matchUnit: [
            { required: true, message: '组赛单位不能为空', trigger: 'blur' }
          ],
          matchType: [
            { required: true, message: '赛制：0：单人赛、1：团体赛不能为空', trigger: 'blur' }
          ],
          userId: [
            { required: true, message: '项目负责人不能为空', trigger: 'blur' }
          ],
          matchStartTime: [
            { required: true, message: '竞赛起始日期不能为空', trigger: 'blur' }
          ],
          matchEndTime: [
            { required: true, message: '竞赛结束日期不能为空', trigger: 'blur' }
          ],
          matchMajor: [
            { required: true, message: '专业不能为空', trigger: 'blur' }
          ],
          hostUnit: [
            { required: true, message: '竞赛主办单位不能为空', trigger: 'blur' }
          ],
          undertakeUnit: [
            { required: true, message: '竞赛承办单位不能为空', trigger: 'blur' }
          ],
          itemInfoTime: [
            { required: true, message: '申请立项日期不能为空', trigger: 'blur' }
          ],
          matchSign: [
            { required: true, message: '论证组赛的目的和意义不能为空', trigger: 'blur' }
          ],
          itemInfoStatus: [
            { required: true, message: '审核状态不能为空', trigger: 'blur' }
          ],
          itemInfoFinish: [
            { required: true, message: '是否已经结题不能为空', trigger: 'blur' }
          ],
          itemInfoIsDel: [
            { required: true, message: '删除标识不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.itemInfoId = id || 0
        this.visible = true
        this.dataForm.itemInfoTime = new Date()
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.itemInfoId) {
            this.$http({
              url: this.$http.adornUrl(`/pm/item/info/${this.dataForm.itemInfoId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.matchName = data.pmItemInfo.matchName
                this.dataForm.matchUnit = data.pmItemInfo.matchUnit
                this.dataForm.matchType = data.pmItemInfo.matchType
                this.dataForm.userId = data.pmItemInfo.userId
                this.dataForm.matchStartTime = data.pmItemInfo.matchStartTime
                this.dataForm.matchEndTime = data.pmItemInfo.matchEndTime
                this.dataForm.matchMajor = data.pmItemInfo.matchMajor
                this.dataForm.hostUnit = data.pmItemInfo.hostUnit
                this.dataForm.undertakeUnit = data.pmItemInfo.undertakeUnit
                this.dataForm.itemInfoTime = data.pmItemInfo.itemInfoTime
                this.dataForm.matchSign = data.pmItemInfo.matchSign
                this.dataForm.itemInfoStatus = data.pmItemInfo.itemInfoStatus
                this.dataForm.itemInfoFinish = data.pmItemInfo.itemInfoFinish
                this.dataForm.itemInfoIsDel = data.pmItemInfo.itemInfoIsDel
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
              url: this.$http.adornUrl(`/pm/item/${!this.dataForm.itemInfoId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'itemInfoId': this.dataForm.itemInfoId || undefined,
                'matchName': this.dataForm.matchName,
                'matchUnit': this.dataForm.matchUnit,
                'matchType': this.dataForm.matchType,
                'userId': this.dataForm.userId,
                'matchStartTime': this.dataForm.matchStartTime,
                'matchEndTime': this.dataForm.matchEndTime,
                'matchMajor': this.dataForm.matchMajor,
                'hostUnit': this.dataForm.hostUnit,
                'undertakeUnit': this.dataForm.undertakeUnit,
                'itemInfoTime': this.dataForm.itemInfoTime,
                'matchSign': this.dataForm.matchSign,
                'itemInfoStatus': this.dataForm.itemInfoStatus,
                'itemInfoFinish': this.dataForm.itemInfoFinish,
                'itemInfoIsDel': this.dataForm.itemInfoIsDel
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
      }
    }
  }
</script>

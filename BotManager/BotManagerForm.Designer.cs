namespace BotManager
{
    partial class BotManagerForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            components = new System.ComponentModel.Container();
            textBoxLog = new TextBox();
            handleClientBindingSource = new BindingSource(components);
            botClientCheckList = new CheckedListBox();
            startSelectBotClientsButton = new Button();
            groupBox1 = new GroupBox();
            selectAllBotClientsButton = new Button();
            tabControl1 = new TabControl();
            tabPage1 = new TabPage();
            runningBotClientsGrid = new DataGridView();
            tabPage2 = new TabPage();
            dataGridView1 = new DataGridView();
            tabPage3 = new TabPage();
            textBoxStartupDelay = new TextBox();
            label1 = new Label();
            groupBox2 = new GroupBox();
            textBoxSelectedAutoLaunch = new TextBox();
            buttonSelectAutoLaunch = new Button();
            textBoxSelectedScript = new TextBox();
            buttonSelectSourceTxt = new Button();
            textBoxSelectedMultiLauncher = new TextBox();
            textBoxSelectedSourceAccounts = new TextBox();
            buttonSelectMultiLauncher = new Button();
            buttonSelectScript = new Button();
            ((System.ComponentModel.ISupportInitialize)handleClientBindingSource).BeginInit();
            groupBox1.SuspendLayout();
            tabControl1.SuspendLayout();
            tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)runningBotClientsGrid).BeginInit();
            tabPage2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)dataGridView1).BeginInit();
            tabPage3.SuspendLayout();
            groupBox2.SuspendLayout();
            SuspendLayout();
            // 
            // textBoxLog
            // 
            textBoxLog.Location = new Point(944, 10);
            textBoxLog.Margin = new Padding(4, 5, 4, 5);
            textBoxLog.Multiline = true;
            textBoxLog.Name = "textBoxLog";
            textBoxLog.ReadOnly = true;
            textBoxLog.ScrollBars = ScrollBars.Vertical;
            textBoxLog.Size = new Size(624, 779);
            textBoxLog.TabIndex = 4;
            // 
            // botClientCheckList
            // 
            botClientCheckList.FormattingEnabled = true;
            botClientCheckList.Location = new Point(8, 150);
            botClientCheckList.Margin = new Padding(4, 5, 4, 5);
            botClientCheckList.Name = "botClientCheckList";
            botClientCheckList.Size = new Size(251, 620);
            botClientCheckList.TabIndex = 6;
            botClientCheckList.ItemCheck += BotClientCheckList_ItemCheck;
            botClientCheckList.SelectedIndexChanged += checkedListBox1_SelectedIndexChanged;
            // 
            // startSelectBotClientsButton
            // 
            startSelectBotClientsButton.Enabled = false;
            startSelectBotClientsButton.Location = new Point(7, 20);
            startSelectBotClientsButton.Margin = new Padding(4, 5, 4, 5);
            startSelectBotClientsButton.Name = "startSelectBotClientsButton";
            startSelectBotClientsButton.Size = new Size(252, 55);
            startSelectBotClientsButton.TabIndex = 8;
            startSelectBotClientsButton.Text = "Start";
            startSelectBotClientsButton.UseVisualStyleBackColor = true;
            startSelectBotClientsButton.Click += buttonStartSelectedClients_Click;
            // 
            // groupBox1
            // 
            groupBox1.Controls.Add(selectAllBotClientsButton);
            groupBox1.Controls.Add(startSelectBotClientsButton);
            groupBox1.Controls.Add(botClientCheckList);
            groupBox1.Location = new Point(9, 10);
            groupBox1.Margin = new Padding(4, 5, 4, 5);
            groupBox1.Name = "groupBox1";
            groupBox1.Padding = new Padding(4, 5, 4, 5);
            groupBox1.Size = new Size(267, 779);
            groupBox1.TabIndex = 15;
            groupBox1.TabStop = false;
            groupBox1.Text = "Start";
            // 
            // selectAllBotClientsButton
            // 
            selectAllBotClientsButton.Location = new Point(7, 85);
            selectAllBotClientsButton.Margin = new Padding(4, 5, 4, 5);
            selectAllBotClientsButton.Name = "selectAllBotClientsButton";
            selectAllBotClientsButton.Size = new Size(252, 55);
            selectAllBotClientsButton.TabIndex = 9;
            selectAllBotClientsButton.Text = "Select All";
            selectAllBotClientsButton.UseVisualStyleBackColor = true;
            selectAllBotClientsButton.Click += selectAllBotClientsButton_Click;
            // 
            // tabControl1
            // 
            tabControl1.Controls.Add(tabPage1);
            tabControl1.Controls.Add(tabPage2);
            tabControl1.Controls.Add(tabPage3);
            tabControl1.Dock = DockStyle.Fill;
            tabControl1.Location = new Point(0, 0);
            tabControl1.Margin = new Padding(4, 5, 4, 5);
            tabControl1.Name = "tabControl1";
            tabControl1.SelectedIndex = 0;
            tabControl1.Size = new Size(1584, 832);
            tabControl1.TabIndex = 19;
            // 
            // tabPage1
            // 
            tabPage1.Controls.Add(runningBotClientsGrid);
            tabPage1.Controls.Add(textBoxLog);
            tabPage1.Controls.Add(groupBox1);
            tabPage1.Location = new Point(4, 29);
            tabPage1.Margin = new Padding(4, 5, 4, 5);
            tabPage1.Name = "tabPage1";
            tabPage1.Padding = new Padding(4, 5, 4, 5);
            tabPage1.Size = new Size(1576, 799);
            tabPage1.TabIndex = 0;
            tabPage1.Text = "Bot commands";
            tabPage1.UseVisualStyleBackColor = true;
            tabPage1.Click += tabPage1_Click;
            // 
            // runningBotClientsGrid
            // 
            runningBotClientsGrid.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            runningBotClientsGrid.Location = new Point(275, 10);
            runningBotClientsGrid.Name = "runningBotClientsGrid";
            runningBotClientsGrid.RowHeadersWidth = 51;
            runningBotClientsGrid.Size = new Size(662, 781);
            runningBotClientsGrid.TabIndex = 16;
            // 
            // tabPage2
            // 
            tabPage2.Controls.Add(dataGridView1);
            tabPage2.Location = new Point(4, 29);
            tabPage2.Margin = new Padding(4, 5, 4, 5);
            tabPage2.Name = "tabPage2";
            tabPage2.Padding = new Padding(4, 5, 4, 5);
            tabPage2.Size = new Size(1576, 799);
            tabPage2.TabIndex = 1;
            tabPage2.Text = "Bot Statistics";
            tabPage2.UseVisualStyleBackColor = true;
            // 
            // dataGridView1
            // 
            dataGridView1.AllowUserToAddRows = false;
            dataGridView1.AllowUserToDeleteRows = false;
            dataGridView1.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridView1.Dock = DockStyle.Fill;
            dataGridView1.Location = new Point(4, 5);
            dataGridView1.Margin = new Padding(4, 5, 4, 5);
            dataGridView1.Name = "dataGridView1";
            dataGridView1.ReadOnly = true;
            dataGridView1.RowHeadersWidth = 51;
            dataGridView1.Size = new Size(1568, 789);
            dataGridView1.TabIndex = 0;
            // 
            // tabPage3
            // 
            tabPage3.Controls.Add(textBoxStartupDelay);
            tabPage3.Controls.Add(label1);
            tabPage3.Controls.Add(groupBox2);
            tabPage3.Location = new Point(4, 29);
            tabPage3.Name = "tabPage3";
            tabPage3.Size = new Size(1576, 799);
            tabPage3.TabIndex = 2;
            tabPage3.Text = "Settings";
            tabPage3.UseVisualStyleBackColor = true;
            // 
            // textBoxStartupDelay
            // 
            textBoxStartupDelay.Location = new Point(167, 242);
            textBoxStartupDelay.Margin = new Padding(4, 5, 4, 5);
            textBoxStartupDelay.Name = "textBoxStartupDelay";
            textBoxStartupDelay.Size = new Size(284, 27);
            textBoxStartupDelay.TabIndex = 25;
            textBoxStartupDelay.Text = "15000";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(18, 245);
            label1.Margin = new Padding(4, 0, 4, 0);
            label1.Name = "label1";
            label1.Size = new Size(97, 20);
            label1.TabIndex = 24;
            label1.Text = "Startup delay";
            // 
            // groupBox2
            // 
            groupBox2.Controls.Add(textBoxSelectedAutoLaunch);
            groupBox2.Controls.Add(buttonSelectAutoLaunch);
            groupBox2.Controls.Add(textBoxSelectedScript);
            groupBox2.Controls.Add(buttonSelectSourceTxt);
            groupBox2.Controls.Add(textBoxSelectedMultiLauncher);
            groupBox2.Controls.Add(textBoxSelectedSourceAccounts);
            groupBox2.Controls.Add(buttonSelectMultiLauncher);
            groupBox2.Controls.Add(buttonSelectScript);
            groupBox2.Location = new Point(9, 5);
            groupBox2.Margin = new Padding(4, 5, 4, 5);
            groupBox2.Name = "groupBox2";
            groupBox2.Padding = new Padding(4, 5, 4, 5);
            groupBox2.Size = new Size(453, 225);
            groupBox2.TabIndex = 17;
            groupBox2.TabStop = false;
            groupBox2.Text = "File Settings";
            // 
            // textBoxSelectedAutoLaunch
            // 
            textBoxSelectedAutoLaunch.Enabled = false;
            textBoxSelectedAutoLaunch.Location = new Point(157, 165);
            textBoxSelectedAutoLaunch.Margin = new Padding(4, 5, 4, 5);
            textBoxSelectedAutoLaunch.Name = "textBoxSelectedAutoLaunch";
            textBoxSelectedAutoLaunch.Size = new Size(284, 27);
            textBoxSelectedAutoLaunch.TabIndex = 16;
            // 
            // buttonSelectAutoLaunch
            // 
            buttonSelectAutoLaunch.Location = new Point(9, 165);
            buttonSelectAutoLaunch.Margin = new Padding(4, 5, 4, 5);
            buttonSelectAutoLaunch.Name = "buttonSelectAutoLaunch";
            buttonSelectAutoLaunch.Size = new Size(141, 31);
            buttonSelectAutoLaunch.TabIndex = 15;
            buttonSelectAutoLaunch.Text = "Auto Launch";
            buttonSelectAutoLaunch.UseVisualStyleBackColor = true;
            // 
            // textBoxSelectedScript
            // 
            textBoxSelectedScript.Enabled = false;
            textBoxSelectedScript.Location = new Point(157, 85);
            textBoxSelectedScript.Margin = new Padding(4, 5, 4, 5);
            textBoxSelectedScript.Name = "textBoxSelectedScript";
            textBoxSelectedScript.Size = new Size(284, 27);
            textBoxSelectedScript.TabIndex = 11;
            textBoxSelectedScript.TextChanged += textBoxSelectedScript_TextChanged;
            // 
            // buttonSelectSourceTxt
            // 
            buttonSelectSourceTxt.Location = new Point(8, 45);
            buttonSelectSourceTxt.Margin = new Padding(4, 5, 4, 5);
            buttonSelectSourceTxt.Name = "buttonSelectSourceTxt";
            buttonSelectSourceTxt.Size = new Size(141, 31);
            buttonSelectSourceTxt.TabIndex = 9;
            buttonSelectSourceTxt.Text = "Source Accounts";
            buttonSelectSourceTxt.UseVisualStyleBackColor = true;
            // 
            // textBoxSelectedMultiLauncher
            // 
            textBoxSelectedMultiLauncher.Enabled = false;
            textBoxSelectedMultiLauncher.Location = new Point(157, 125);
            textBoxSelectedMultiLauncher.Margin = new Padding(4, 5, 4, 5);
            textBoxSelectedMultiLauncher.Name = "textBoxSelectedMultiLauncher";
            textBoxSelectedMultiLauncher.Size = new Size(284, 27);
            textBoxSelectedMultiLauncher.TabIndex = 14;
            // 
            // textBoxSelectedSourceAccounts
            // 
            textBoxSelectedSourceAccounts.Enabled = false;
            textBoxSelectedSourceAccounts.Location = new Point(157, 45);
            textBoxSelectedSourceAccounts.Margin = new Padding(4, 5, 4, 5);
            textBoxSelectedSourceAccounts.Name = "textBoxSelectedSourceAccounts";
            textBoxSelectedSourceAccounts.Size = new Size(284, 27);
            textBoxSelectedSourceAccounts.TabIndex = 10;
            // 
            // buttonSelectMultiLauncher
            // 
            buttonSelectMultiLauncher.Location = new Point(8, 125);
            buttonSelectMultiLauncher.Margin = new Padding(4, 5, 4, 5);
            buttonSelectMultiLauncher.Name = "buttonSelectMultiLauncher";
            buttonSelectMultiLauncher.Size = new Size(141, 31);
            buttonSelectMultiLauncher.TabIndex = 13;
            buttonSelectMultiLauncher.Text = "Multi Launch";
            buttonSelectMultiLauncher.UseVisualStyleBackColor = true;
            // 
            // buttonSelectScript
            // 
            buttonSelectScript.Location = new Point(8, 83);
            buttonSelectScript.Margin = new Padding(4, 5, 4, 5);
            buttonSelectScript.Name = "buttonSelectScript";
            buttonSelectScript.Size = new Size(141, 32);
            buttonSelectScript.TabIndex = 12;
            buttonSelectScript.Text = "Script";
            buttonSelectScript.UseVisualStyleBackColor = true;
            buttonSelectScript.Click += buttonSelectScript_Click_1;
            // 
            // BotManagerForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1584, 832);
            Controls.Add(tabControl1);
            Margin = new Padding(4, 5, 4, 5);
            Name = "BotManagerForm";
            Text = "BotManager";
            Load += BotManagerForm_Load;
            ((System.ComponentModel.ISupportInitialize)handleClientBindingSource).EndInit();
            groupBox1.ResumeLayout(false);
            tabControl1.ResumeLayout(false);
            tabPage1.ResumeLayout(false);
            tabPage1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)runningBotClientsGrid).EndInit();
            tabPage2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)dataGridView1).EndInit();
            tabPage3.ResumeLayout(false);
            tabPage3.PerformLayout();
            groupBox2.ResumeLayout(false);
            groupBox2.PerformLayout();
            ResumeLayout(false);

        }

        #endregion
        public System.Windows.Forms.CheckedListBox botClientCheckList;
        private System.Windows.Forms.BindingSource handleClientBindingSource;

        public System.Windows.Forms.TextBox textBoxLog;
        private System.Windows.Forms.Button startSelectBotClientsButton;

        private System.Windows.Forms.GroupBox groupBox1;
        public System.Windows.Forms.DataGridView dataGridView1;


        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private TabPage tabPage3;
        private TextBox textBoxStartupDelay;
        private Label label1;
        private GroupBox groupBox2;
        public TextBox textBoxSelectedAutoLaunch;
        private Button buttonSelectAutoLaunch;
        public TextBox textBoxSelectedScript;
        private Button buttonSelectSourceTxt;
        public TextBox textBoxSelectedMultiLauncher;
        public TextBox textBoxSelectedSourceAccounts;
        private Button buttonSelectMultiLauncher;
        private Button buttonSelectScript;
        private Button selectAllBotClientsButton;
        private DataGridView runningBotClientsGrid;
    }
}


﻿namespace BotManager
{
    partial class Form1
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
            this.components = new System.ComponentModel.Container();
            this.listBoxClients = new System.Windows.Forms.ListBox();
            this.buttonTradeAllClients = new System.Windows.Forms.Button();
            this.buttonStopTradingAllClients = new System.Windows.Forms.Button();
            this.textBoxLog = new System.Windows.Forms.TextBox();
            this.handleClientBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.buttonRefreshClient = new System.Windows.Forms.Button();
            this.checkedListBox1 = new System.Windows.Forms.CheckedListBox();
            this.buttonStartAllClients = new System.Windows.Forms.Button();
            this.buttonStartSelectedClients = new System.Windows.Forms.Button();
            this.buttonSelectSourceTxt = new System.Windows.Forms.Button();
            this.textBoxSelectedSourceAccounts = new System.Windows.Forms.TextBox();
            this.textBoxSelectedScript = new System.Windows.Forms.TextBox();
            this.buttonSelectScript = new System.Windows.Forms.Button();
            this.buttonSelectMultiLauncher = new System.Windows.Forms.Button();
            this.textBoxSelectedMultiLauncher = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.checkBoxMinimizedClient = new System.Windows.Forms.CheckBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.textBoxSelectedAutoLaunch = new System.Windows.Forms.TextBox();
            this.buttonSelectAutoLaunch = new System.Windows.Forms.Button();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.buttonTradeSelectedClients = new System.Windows.Forms.Button();
            this.checkedListBox2 = new System.Windows.Forms.CheckedListBox();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.checkedListBox4 = new System.Windows.Forms.CheckedListBox();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.buttonRestartSelectedClients = new System.Windows.Forms.Button();
            this.checkedListBox3 = new System.Windows.Forms.CheckedListBox();
            this.buttonEndAllSelectedClients = new System.Windows.Forms.Button();
            this.buttonStopSelectedClients = new System.Windows.Forms.Button();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.label1 = new System.Windows.Forms.Label();
            this.textBoxStartupDelay = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.handleClientBindingSource)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox5.SuspendLayout();
            this.tabPage2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // listBoxClients
            // 
            this.listBoxClients.FormattingEnabled = true;
            this.listBoxClients.Location = new System.Drawing.Point(6, 230);
            this.listBoxClients.Name = "listBoxClients";
            this.listBoxClients.Size = new System.Drawing.Size(188, 264);
            this.listBoxClients.TabIndex = 1;
            // 
            // buttonTradeAllClients
            // 
            this.buttonTradeAllClients.Location = new System.Drawing.Point(6, 13);
            this.buttonTradeAllClients.Name = "buttonTradeAllClients";
            this.buttonTradeAllClients.Size = new System.Drawing.Size(188, 36);
            this.buttonTradeAllClients.TabIndex = 2;
            this.buttonTradeAllClients.Text = "Trade All Clients";
            this.buttonTradeAllClients.UseVisualStyleBackColor = true;
            this.buttonTradeAllClients.Click += new System.EventHandler(this.buttonStartTradeAllClients_Click);
            // 
            // buttonStopTradingAllClients
            // 
            this.buttonStopTradingAllClients.Location = new System.Drawing.Point(6, 93);
            this.buttonStopTradingAllClients.Name = "buttonStopTradingAllClients";
            this.buttonStopTradingAllClients.Size = new System.Drawing.Size(188, 36);
            this.buttonStopTradingAllClients.TabIndex = 3;
            this.buttonStopTradingAllClients.Text = "Stop Trade All Clients";
            this.buttonStopTradingAllClients.UseVisualStyleBackColor = true;
            this.buttonStopTradingAllClients.Click += new System.EventHandler(this.buttonStopTradeClients_Click);
            // 
            // textBoxLog
            // 
            this.textBoxLog.Location = new System.Drawing.Point(6, 54);
            this.textBoxLog.Multiline = true;
            this.textBoxLog.Name = "textBoxLog";
            this.textBoxLog.ReadOnly = true;
            this.textBoxLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBoxLog.Size = new System.Drawing.Size(188, 170);
            this.textBoxLog.TabIndex = 4;
            // 
            // buttonRefreshClient
            // 
            this.buttonRefreshClient.Location = new System.Drawing.Point(6, 13);
            this.buttonRefreshClient.Name = "buttonRefreshClient";
            this.buttonRefreshClient.Size = new System.Drawing.Size(188, 36);
            this.buttonRefreshClient.TabIndex = 5;
            this.buttonRefreshClient.Text = "Refresh Clients";
            this.buttonRefreshClient.UseVisualStyleBackColor = true;
            // 
            // checkedListBox1
            // 
            this.checkedListBox1.FormattingEnabled = true;
            this.checkedListBox1.Location = new System.Drawing.Point(5, 145);
            this.checkedListBox1.Name = "checkedListBox1";
            this.checkedListBox1.Size = new System.Drawing.Size(189, 349);
            this.checkedListBox1.TabIndex = 6;
            // 
            // buttonStartAllClients
            // 
            this.buttonStartAllClients.Location = new System.Drawing.Point(5, 52);
            this.buttonStartAllClients.Name = "buttonStartAllClients";
            this.buttonStartAllClients.Size = new System.Drawing.Size(189, 36);
            this.buttonStartAllClients.TabIndex = 7;
            this.buttonStartAllClients.Text = "Start All Clients";
            this.buttonStartAllClients.UseVisualStyleBackColor = true;
            this.buttonStartAllClients.Click += new System.EventHandler(this.buttonStartAllClients_Click);
            // 
            // buttonStartSelectedClients
            // 
            this.buttonStartSelectedClients.Location = new System.Drawing.Point(5, 13);
            this.buttonStartSelectedClients.Name = "buttonStartSelectedClients";
            this.buttonStartSelectedClients.Size = new System.Drawing.Size(189, 36);
            this.buttonStartSelectedClients.TabIndex = 8;
            this.buttonStartSelectedClients.Text = "Start Selected Clients";
            this.buttonStartSelectedClients.UseVisualStyleBackColor = true;
            this.buttonStartSelectedClients.Click += new System.EventHandler(this.buttonStartSelectedClients_Click);
            // 
            // buttonSelectSourceTxt
            // 
            this.buttonSelectSourceTxt.Location = new System.Drawing.Point(6, 29);
            this.buttonSelectSourceTxt.Name = "buttonSelectSourceTxt";
            this.buttonSelectSourceTxt.Size = new System.Drawing.Size(106, 20);
            this.buttonSelectSourceTxt.TabIndex = 9;
            this.buttonSelectSourceTxt.Text = "Source Accounts";
            this.buttonSelectSourceTxt.UseVisualStyleBackColor = true;
            this.buttonSelectSourceTxt.Click += new System.EventHandler(this.buttonSelectSourceTxt_Click);
            // 
            // textBoxSelectedSourceAccounts
            // 
            this.textBoxSelectedSourceAccounts.Enabled = false;
            this.textBoxSelectedSourceAccounts.Location = new System.Drawing.Point(118, 29);
            this.textBoxSelectedSourceAccounts.Name = "textBoxSelectedSourceAccounts";
            this.textBoxSelectedSourceAccounts.Size = new System.Drawing.Size(214, 20);
            this.textBoxSelectedSourceAccounts.TabIndex = 10;
            // 
            // textBoxSelectedScript
            // 
            this.textBoxSelectedScript.Enabled = false;
            this.textBoxSelectedScript.Location = new System.Drawing.Point(118, 55);
            this.textBoxSelectedScript.Name = "textBoxSelectedScript";
            this.textBoxSelectedScript.Size = new System.Drawing.Size(214, 20);
            this.textBoxSelectedScript.TabIndex = 11;
            // 
            // buttonSelectScript
            // 
            this.buttonSelectScript.Location = new System.Drawing.Point(6, 54);
            this.buttonSelectScript.Name = "buttonSelectScript";
            this.buttonSelectScript.Size = new System.Drawing.Size(106, 21);
            this.buttonSelectScript.TabIndex = 12;
            this.buttonSelectScript.Text = "Script";
            this.buttonSelectScript.UseVisualStyleBackColor = true;
            this.buttonSelectScript.Click += new System.EventHandler(this.buttonSelectScript_Click);
            // 
            // buttonSelectMultiLauncher
            // 
            this.buttonSelectMultiLauncher.Location = new System.Drawing.Point(6, 81);
            this.buttonSelectMultiLauncher.Name = "buttonSelectMultiLauncher";
            this.buttonSelectMultiLauncher.Size = new System.Drawing.Size(106, 20);
            this.buttonSelectMultiLauncher.TabIndex = 13;
            this.buttonSelectMultiLauncher.Text = "Multi Launch";
            this.buttonSelectMultiLauncher.UseVisualStyleBackColor = true;
            this.buttonSelectMultiLauncher.Click += new System.EventHandler(this.buttonSelectMultiLauncher_Click);
            // 
            // textBoxSelectedMultiLauncher
            // 
            this.textBoxSelectedMultiLauncher.Enabled = false;
            this.textBoxSelectedMultiLauncher.Location = new System.Drawing.Point(118, 81);
            this.textBoxSelectedMultiLauncher.Name = "textBoxSelectedMultiLauncher";
            this.textBoxSelectedMultiLauncher.Size = new System.Drawing.Size(214, 20);
            this.textBoxSelectedMultiLauncher.TabIndex = 14;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.checkBoxMinimizedClient);
            this.groupBox1.Controls.Add(this.buttonStartSelectedClients);
            this.groupBox1.Controls.Add(this.buttonStartAllClients);
            this.groupBox1.Controls.Add(this.checkedListBox1);
            this.groupBox1.Location = new System.Drawing.Point(420, 9);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(200, 500);
            this.groupBox1.TabIndex = 15;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Start";
            // 
            // checkBoxMinimizedClient
            // 
            this.checkBoxMinimizedClient.AutoSize = true;
            this.checkBoxMinimizedClient.Checked = true;
            this.checkBoxMinimizedClient.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxMinimizedClient.Location = new System.Drawing.Point(6, 104);
            this.checkBoxMinimizedClient.Name = "checkBoxMinimizedClient";
            this.checkBoxMinimizedClient.Size = new System.Drawing.Size(124, 17);
            this.checkBoxMinimizedClient.TabIndex = 9;
            this.checkBoxMinimizedClient.Text = "Run Client Minimized";
            this.checkBoxMinimizedClient.UseVisualStyleBackColor = true;
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.textBoxSelectedAutoLaunch);
            this.groupBox2.Controls.Add(this.buttonSelectAutoLaunch);
            this.groupBox2.Controls.Add(this.textBoxSelectedScript);
            this.groupBox2.Controls.Add(this.buttonSelectSourceTxt);
            this.groupBox2.Controls.Add(this.textBoxSelectedMultiLauncher);
            this.groupBox2.Controls.Add(this.textBoxSelectedSourceAccounts);
            this.groupBox2.Controls.Add(this.buttonSelectMultiLauncher);
            this.groupBox2.Controls.Add(this.buttonSelectScript);
            this.groupBox2.Location = new System.Drawing.Point(1038, 9);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(340, 146);
            this.groupBox2.TabIndex = 16;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "File Settings";
            // 
            // textBoxSelectedAutoLaunch
            // 
            this.textBoxSelectedAutoLaunch.Enabled = false;
            this.textBoxSelectedAutoLaunch.Location = new System.Drawing.Point(118, 107);
            this.textBoxSelectedAutoLaunch.Name = "textBoxSelectedAutoLaunch";
            this.textBoxSelectedAutoLaunch.Size = new System.Drawing.Size(214, 20);
            this.textBoxSelectedAutoLaunch.TabIndex = 16;
            // 
            // buttonSelectAutoLaunch
            // 
            this.buttonSelectAutoLaunch.Location = new System.Drawing.Point(7, 107);
            this.buttonSelectAutoLaunch.Name = "buttonSelectAutoLaunch";
            this.buttonSelectAutoLaunch.Size = new System.Drawing.Size(106, 20);
            this.buttonSelectAutoLaunch.TabIndex = 15;
            this.buttonSelectAutoLaunch.Text = "Auto Launch";
            this.buttonSelectAutoLaunch.UseVisualStyleBackColor = true;
            this.buttonSelectAutoLaunch.Click += new System.EventHandler(this.buttonSelectAutoLaunch_Click);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.buttonRefreshClient);
            this.groupBox3.Controls.Add(this.textBoxLog);
            this.groupBox3.Controls.Add(this.listBoxClients);
            this.groupBox3.Location = new System.Drawing.Point(8, 9);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(200, 500);
            this.groupBox3.TabIndex = 17;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Bot Logs";
            this.groupBox3.Enter += new System.EventHandler(this.groupBox3_Enter);
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.buttonTradeSelectedClients);
            this.groupBox4.Controls.Add(this.checkedListBox2);
            this.groupBox4.Controls.Add(this.buttonTradeAllClients);
            this.groupBox4.Controls.Add(this.buttonStopTradingAllClients);
            this.groupBox4.Location = new System.Drawing.Point(214, 9);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(200, 500);
            this.groupBox4.TabIndex = 18;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "Trade";
            this.groupBox4.Enter += new System.EventHandler(this.groupBox4_Enter);
            // 
            // buttonTradeSelectedClients
            // 
            this.buttonTradeSelectedClients.Location = new System.Drawing.Point(6, 54);
            this.buttonTradeSelectedClients.Name = "buttonTradeSelectedClients";
            this.buttonTradeSelectedClients.Size = new System.Drawing.Size(188, 33);
            this.buttonTradeSelectedClients.TabIndex = 5;
            this.buttonTradeSelectedClients.Text = "Trade Selected Clients";
            this.buttonTradeSelectedClients.UseVisualStyleBackColor = true;
            this.buttonTradeSelectedClients.Click += new System.EventHandler(this.buttonStartTradeSelectedClients_Click);
            // 
            // checkedListBox2
            // 
            this.checkedListBox2.FormattingEnabled = true;
            this.checkedListBox2.Location = new System.Drawing.Point(6, 145);
            this.checkedListBox2.Name = "checkedListBox2";
            this.checkedListBox2.Size = new System.Drawing.Size(188, 349);
            this.checkedListBox2.TabIndex = 4;
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tabControl1.Location = new System.Drawing.Point(0, 0);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(1393, 541);
            this.tabControl1.TabIndex = 19;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.textBoxStartupDelay);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.groupBox6);
            this.tabPage1.Controls.Add(this.groupBox5);
            this.tabPage1.Controls.Add(this.groupBox3);
            this.tabPage1.Controls.Add(this.groupBox4);
            this.tabPage1.Controls.Add(this.groupBox1);
            this.tabPage1.Controls.Add(this.groupBox2);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(1385, 515);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Bot commands";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.tabPage1.Click += new System.EventHandler(this.tabPage1_Click);
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.checkedListBox4);
            this.groupBox6.Controls.Add(this.button2);
            this.groupBox6.Controls.Add(this.button3);
            this.groupBox6.Location = new System.Drawing.Point(832, 9);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(200, 500);
            this.groupBox6.TabIndex = 20;
            this.groupBox6.TabStop = false;
            this.groupBox6.Text = "Reset";
            // 
            // checkedListBox4
            // 
            this.checkedListBox4.FormattingEnabled = true;
            this.checkedListBox4.Location = new System.Drawing.Point(7, 145);
            this.checkedListBox4.Name = "checkedListBox4";
            this.checkedListBox4.Size = new System.Drawing.Size(187, 349);
            this.checkedListBox4.TabIndex = 2;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(6, 54);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(188, 36);
            this.button2.TabIndex = 1;
            this.button2.Text = "Reset All Clients";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(6, 13);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(188, 36);
            this.button3.TabIndex = 0;
            this.button3.Text = "Reset Selected Clients";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.buttonRestartSelectedClients);
            this.groupBox5.Controls.Add(this.checkedListBox3);
            this.groupBox5.Controls.Add(this.buttonEndAllSelectedClients);
            this.groupBox5.Controls.Add(this.buttonStopSelectedClients);
            this.groupBox5.Location = new System.Drawing.Point(626, 9);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(200, 500);
            this.groupBox5.TabIndex = 19;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "Stop";
            // 
            // buttonRestartSelectedClients
            // 
            this.buttonRestartSelectedClients.Location = new System.Drawing.Point(7, 96);
            this.buttonRestartSelectedClients.Name = "buttonRestartSelectedClients";
            this.buttonRestartSelectedClients.Size = new System.Drawing.Size(187, 35);
            this.buttonRestartSelectedClients.TabIndex = 3;
            this.buttonRestartSelectedClients.Text = "Restart Selected Clients";
            this.buttonRestartSelectedClients.UseVisualStyleBackColor = true;
            this.buttonRestartSelectedClients.Click += new System.EventHandler(this.buttonRestartSelectedClients_Click);
            // 
            // checkedListBox3
            // 
            this.checkedListBox3.FormattingEnabled = true;
            this.checkedListBox3.Location = new System.Drawing.Point(6, 145);
            this.checkedListBox3.Name = "checkedListBox3";
            this.checkedListBox3.Size = new System.Drawing.Size(188, 349);
            this.checkedListBox3.TabIndex = 2;
            // 
            // buttonEndAllSelectedClients
            // 
            this.buttonEndAllSelectedClients.Location = new System.Drawing.Point(6, 54);
            this.buttonEndAllSelectedClients.Name = "buttonEndAllSelectedClients";
            this.buttonEndAllSelectedClients.Size = new System.Drawing.Size(188, 36);
            this.buttonEndAllSelectedClients.TabIndex = 1;
            this.buttonEndAllSelectedClients.Text = "End All Clients";
            this.buttonEndAllSelectedClients.UseVisualStyleBackColor = true;
            this.buttonEndAllSelectedClients.Click += new System.EventHandler(this.buttonEndAllSelectedClients_Click);
            // 
            // buttonStopSelectedClients
            // 
            this.buttonStopSelectedClients.Location = new System.Drawing.Point(6, 13);
            this.buttonStopSelectedClients.Name = "buttonStopSelectedClients";
            this.buttonStopSelectedClients.Size = new System.Drawing.Size(188, 36);
            this.buttonStopSelectedClients.TabIndex = 0;
            this.buttonStopSelectedClients.Text = "Stop Selected Clients";
            this.buttonStopSelectedClients.UseVisualStyleBackColor = true;
            this.buttonStopSelectedClients.Click += new System.EventHandler(this.buttonStopSelectedClients_Click);
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.dataGridView1);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(1385, 515);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Bot Statistics";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dataGridView1.Location = new System.Drawing.Point(3, 3);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.Size = new System.Drawing.Size(1379, 509);
            this.dataGridView1.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(1044, 180);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(69, 13);
            this.label1.TabIndex = 22;
            this.label1.Text = "Startup delay";
            // 
            // textBoxStartupDelay
            // 
            this.textBoxStartupDelay.Location = new System.Drawing.Point(1156, 173);
            this.textBoxStartupDelay.Name = "textBoxStartupDelay";
            this.textBoxStartupDelay.Size = new System.Drawing.Size(214, 20);
            this.textBoxStartupDelay.TabIndex = 23;
            this.textBoxStartupDelay.Text = "15000";
            this.textBoxStartupDelay.TextChanged += new System.EventHandler(this.textBoxStartupDelay_TextChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1393, 541);
            this.Controls.Add(this.tabControl1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.handleClientBindingSource)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.groupBox6.ResumeLayout(false);
            this.groupBox5.ResumeLayout(false);
            this.tabPage2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion



        public System.Windows.Forms.ListBox listBoxClients;
        public System.Windows.Forms.CheckedListBox checkedListBox1;
        public System.Windows.Forms.CheckedListBox checkedListBox2;
        public System.Windows.Forms.CheckedListBox checkedListBox3;
        private System.Windows.Forms.BindingSource handleClientBindingSource;

        public System.Windows.Forms.TextBox textBoxLog;
        public System.Windows.Forms.TextBox textBoxSelectedSourceAccounts;
        public System.Windows.Forms.TextBox textBoxSelectedMultiLauncher;
        public System.Windows.Forms.TextBox textBoxSelectedScript;
        public System.Windows.Forms.TextBox textBoxSelectedAutoLaunch;
        private System.Windows.Forms.Button buttonTradeAllClients;
        private System.Windows.Forms.Button buttonStopTradingAllClients;
        private System.Windows.Forms.Button buttonSelectScript;
        private System.Windows.Forms.Button buttonSelectMultiLauncher; 
        private System.Windows.Forms.Button buttonStartAllClients;
        private System.Windows.Forms.Button buttonStartSelectedClients;
        private System.Windows.Forms.Button buttonSelectSourceTxt; 
        private System.Windows.Forms.Button buttonRefreshClient;
        private System.Windows.Forms.Button buttonEndAllSelectedClients;
        private System.Windows.Forms.Button buttonStopSelectedClients;
        private System.Windows.Forms.Button buttonTradeSelectedClients;
        private System.Windows.Forms.Button buttonSelectAutoLaunch;

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.GroupBox groupBox5;


        private System.Windows.Forms.CheckBox checkBoxMinimizedClient;
        public System.Windows.Forms.DataGridView dataGridView1;


        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Button buttonRestartSelectedClients;
        private System.Windows.Forms.GroupBox groupBox6;
        public System.Windows.Forms.CheckedListBox checkedListBox4;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBoxStartupDelay;
    }
}


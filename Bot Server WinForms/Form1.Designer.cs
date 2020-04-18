namespace Bot_Server_WinForms
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
            this.buttonStartServer = new System.Windows.Forms.Button();
            this.listBoxClients = new System.Windows.Forms.ListBox();
            this.buttonTradeClients = new System.Windows.Forms.Button();
            this.buttonStopTradingClients = new System.Windows.Forms.Button();
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
            ((System.ComponentModel.ISupportInitialize)(this.handleClientBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // buttonStartServer
            // 
            this.buttonStartServer.Location = new System.Drawing.Point(12, 12);
            this.buttonStartServer.Name = "buttonStartServer";
            this.buttonStartServer.Size = new System.Drawing.Size(360, 36);
            this.buttonStartServer.TabIndex = 0;
            this.buttonStartServer.Text = "Start Server";
            this.buttonStartServer.UseVisualStyleBackColor = true;
            this.buttonStartServer.Click += new System.EventHandler(this.buttonStartServer_Click);
            // 
            // listBoxClients
            // 
            this.listBoxClients.FormattingEnabled = true;
            this.listBoxClients.Location = new System.Drawing.Point(12, 420);
            this.listBoxClients.Name = "listBoxClients";
            this.listBoxClients.Size = new System.Drawing.Size(361, 173);
            this.listBoxClients.TabIndex = 1;
            // 
            // buttonTradeClients
            // 
            this.buttonTradeClients.Location = new System.Drawing.Point(12, 54);
            this.buttonTradeClients.Name = "buttonTradeClients";
            this.buttonTradeClients.Size = new System.Drawing.Size(360, 36);
            this.buttonTradeClients.TabIndex = 2;
            this.buttonTradeClients.Text = "Trade Clients";
            this.buttonTradeClients.UseVisualStyleBackColor = true;
            this.buttonTradeClients.Click += new System.EventHandler(this.buttonStartClients_Click);
            // 
            // buttonStopTradingClients
            // 
            this.buttonStopTradingClients.Location = new System.Drawing.Point(11, 96);
            this.buttonStopTradingClients.Name = "buttonStopTradingClients";
            this.buttonStopTradingClients.Size = new System.Drawing.Size(360, 36);
            this.buttonStopTradingClients.TabIndex = 3;
            this.buttonStopTradingClients.Text = "Stop Trade Clients";
            this.buttonStopTradingClients.UseVisualStyleBackColor = true;
            this.buttonStopTradingClients.Click += new System.EventHandler(this.buttonStopClients_Click);
            // 
            // textBoxLog
            // 
            this.textBoxLog.Location = new System.Drawing.Point(11, 197);
            this.textBoxLog.Multiline = true;
            this.textBoxLog.Name = "textBoxLog";
            this.textBoxLog.ReadOnly = true;
            this.textBoxLog.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBoxLog.Size = new System.Drawing.Size(361, 217);
            this.textBoxLog.TabIndex = 4;
            // 
            // buttonRefreshClient
            // 
            this.buttonRefreshClient.Location = new System.Drawing.Point(12, 138);
            this.buttonRefreshClient.Name = "buttonRefreshClient";
            this.buttonRefreshClient.Size = new System.Drawing.Size(360, 36);
            this.buttonRefreshClient.TabIndex = 5;
            this.buttonRefreshClient.Text = "Refresh Clients";
            this.buttonRefreshClient.UseVisualStyleBackColor = true;
            // 
            // checkedListBox1
            // 
            this.checkedListBox1.FormattingEnabled = true;
            this.checkedListBox1.Location = new System.Drawing.Point(379, 420);
            this.checkedListBox1.Name = "checkedListBox1";
            this.checkedListBox1.Size = new System.Drawing.Size(510, 169);
            this.checkedListBox1.TabIndex = 6;
            // 
            // buttonStartAllClients
            // 
            this.buttonStartAllClients.Location = new System.Drawing.Point(388, 138);
            this.buttonStartAllClients.Name = "buttonStartAllClients";
            this.buttonStartAllClients.Size = new System.Drawing.Size(195, 36);
            this.buttonStartAllClients.TabIndex = 7;
            this.buttonStartAllClients.Text = "Start All Clients";
            this.buttonStartAllClients.UseVisualStyleBackColor = true;
            this.buttonStartAllClients.Click += new System.EventHandler(this.buttonStartAllClients_Click);
            // 
            // buttonStartSelectedClients
            // 
            this.buttonStartSelectedClients.Location = new System.Drawing.Point(388, 96);
            this.buttonStartSelectedClients.Name = "buttonStartSelectedClients";
            this.buttonStartSelectedClients.Size = new System.Drawing.Size(195, 36);
            this.buttonStartSelectedClients.TabIndex = 8;
            this.buttonStartSelectedClients.Text = "Start Selected Clients";
            this.buttonStartSelectedClients.UseVisualStyleBackColor = true;
            // 
            // buttonSelectSourceTxt
            // 
            this.buttonSelectSourceTxt.Location = new System.Drawing.Point(696, 28);
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
            this.textBoxSelectedSourceAccounts.Location = new System.Drawing.Point(808, 28);
            this.textBoxSelectedSourceAccounts.Name = "textBoxSelectedSourceAccounts";
            this.textBoxSelectedSourceAccounts.Size = new System.Drawing.Size(215, 20);
            this.textBoxSelectedSourceAccounts.TabIndex = 10;
            // 
            // textBoxSelectedScript
            // 
            this.textBoxSelectedScript.Enabled = false;
            this.textBoxSelectedScript.Location = new System.Drawing.Point(808, 54);
            this.textBoxSelectedScript.Name = "textBoxSelectedScript";
            this.textBoxSelectedScript.Size = new System.Drawing.Size(215, 20);
            this.textBoxSelectedScript.TabIndex = 11;
            // 
            // buttonSelectScript
            // 
            this.buttonSelectScript.Location = new System.Drawing.Point(696, 53);
            this.buttonSelectScript.Name = "buttonSelectScript";
            this.buttonSelectScript.Size = new System.Drawing.Size(106, 21);
            this.buttonSelectScript.TabIndex = 12;
            this.buttonSelectScript.Text = "Script";
            this.buttonSelectScript.UseVisualStyleBackColor = true;
            this.buttonSelectScript.Click += new System.EventHandler(this.buttonSelectScript_Click);
            // 
            // buttonSelectMultiLauncher
            // 
            this.buttonSelectMultiLauncher.Location = new System.Drawing.Point(696, 80);
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
            this.textBoxSelectedMultiLauncher.Location = new System.Drawing.Point(808, 80);
            this.textBoxSelectedMultiLauncher.Name = "textBoxSelectedMultiLauncher";
            this.textBoxSelectedMultiLauncher.Size = new System.Drawing.Size(214, 20);
            this.textBoxSelectedMultiLauncher.TabIndex = 14;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1035, 606);
            this.Controls.Add(this.textBoxSelectedMultiLauncher);
            this.Controls.Add(this.buttonSelectMultiLauncher);
            this.Controls.Add(this.buttonSelectScript);
            this.Controls.Add(this.textBoxSelectedScript);
            this.Controls.Add(this.textBoxSelectedSourceAccounts);
            this.Controls.Add(this.buttonSelectSourceTxt);
            this.Controls.Add(this.buttonStartSelectedClients);
            this.Controls.Add(this.buttonStartAllClients);
            this.Controls.Add(this.checkedListBox1);
            this.Controls.Add(this.buttonRefreshClient);
            this.Controls.Add(this.textBoxLog);
            this.Controls.Add(this.buttonStopTradingClients);
            this.Controls.Add(this.buttonTradeClients);
            this.Controls.Add(this.listBoxClients);
            this.Controls.Add(this.buttonStartServer);
            this.Name = "Form1";
            this.Text = "Form1";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form1_FormClosed);
            ((System.ComponentModel.ISupportInitialize)(this.handleClientBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonStartServer;
        private System.Windows.Forms.Button buttonTradeClients;
        private System.Windows.Forms.Button buttonStopTradingClients;
        public System.Windows.Forms.TextBox textBoxLog;
        public System.Windows.Forms.ListBox listBoxClients;
        private System.Windows.Forms.BindingSource handleClientBindingSource;
        private System.Windows.Forms.Button buttonRefreshClient;
        private System.Windows.Forms.CheckedListBox checkedListBox1;
        private System.Windows.Forms.Button buttonStartAllClients;
        private System.Windows.Forms.Button buttonStartSelectedClients;
        private System.Windows.Forms.Button buttonSelectSourceTxt;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.TextBox textBoxSelectedSourceAccounts;
        private System.Windows.Forms.TextBox textBoxSelectedScript;
        private System.Windows.Forms.Button buttonSelectScript;
        private System.Windows.Forms.Button buttonSelectMultiLauncher;
        private System.Windows.Forms.TextBox textBoxSelectedMultiLauncher;
    }
}


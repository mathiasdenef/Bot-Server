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
            this.listBoxClients.Location = new System.Drawing.Point(11, 420);
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
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(384, 606);
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
    }
}

